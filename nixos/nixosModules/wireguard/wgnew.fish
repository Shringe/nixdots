# This script generates new wg config files for clients to connect to my server.
# The server is this server, and the client is the device I want to allow to connect.

function gen_private
    wg genkey
end

function gen_public
    set -l private $argv[1]
    echo $private | wg pubkey
end

function gen_pair
    set -l private (gen_private)
    set -l public (gen_public $private)
    echo $private
    echo $public
end

function get_server_public
    echo (gen_public (cat "$server_private_path"))
end

function make_toml
    set -l private_key $argv[1]
    set -l dns $argv[2]
    set -l address "$argv[3]/24"
    set -l public_key $argv[4]
    set -l allowed_ip $argv[5]
    set -l endpoint $argv[6]

    printf "[Interface]\nPrivateKey = %s\nDNS = %s\nAddress = %s\n\n[Peer]\nPublicKey = %s\nAllowedIPs = %s\nEndpoint = %s\n" \
        $private_key $dns $address $public_key $allowed_ip $endpoint
end

function make_peer
    printf "{ # %s\n  publicKey = \"%s\";\n  allowedIPs = [ \"%s/32\" ];\n}\n" \
        $argv[3] $argv[1] $argv[2]
end

set server_private_path $argv[1]
set server_ip_local $argv[2]
set server_ip_public $argv[3]
set server_ip_private $argv[4]
set server_port $argv[5]
set allowed_ip $argv[6]
set client_num $argv[7]
set client_name $argv[8]

set server_dns $server_ip_local
set server_address "$server_ip_private.$client_num"
set endpoint "$server_ip_public:$server_port"

set server_public (get_server_public)
set client_pair (gen_pair)

echo "Add to server wireguard peer list: =========="
make_peer $client_pair[2] "\${cfg.private_ip}.$client_num" $client_name
echo ""

echo "Send to new client: ========================="
make_toml $client_pair[1] \
    $server_dns \
    $server_address \
    $server_public \
    $allowed_ip \
    $endpoint
