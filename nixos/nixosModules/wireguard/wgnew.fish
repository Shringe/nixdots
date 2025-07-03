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

function gen_preshared
    wg genpsk
end

function get_server_public
    echo (gen_public (cat "$server_private_path"))
end

function make_toml
    printf "%s\n" \
        "[Interface]" \
        "PrivateKey = $argv[1]" \
        "DNS = $argv[2]" \
        "Address = $argv[3]/24" \
        "" \
        "[Peer]" \
        "PublicKey = $argv[4]" \
        "PresharedKey = $argv[5]" \
        "AllowedIPs = $argv[6]" \
        "Endpoint = $argv[7]"
end

function make_peer
    echo "      (mkPeer $argv[1] \"$argv[2]\" \"$argv[3]\")"
end

function make_secret
    echo "      \"preshared/$argv[1]\" = key;"
end

function make_sops
    echo "    $argv[1]: $argv[2]"
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
set preshared (gen_preshared)

echo "Add this preshared key to the sops file: ===="
make_sops $client_name $preshared
echo ""

echo "Add to sops secret list: ===================="
make_secret $client_name
echo ""

echo "Add to server wireguard peer list: =========="
make_peer $client_num $client_name $client_pair[2]
echo ""

echo "Send to new client: ========================="
make_toml $client_pair[1] \
    $server_dns \
    $server_address \
    $server_public \
    $preshared \
    $allowed_ip \
    $endpoint
