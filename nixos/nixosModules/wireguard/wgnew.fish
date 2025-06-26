# Example:
# [Interface]
# PrivateKey = WGpL3/ejM5L9ngLoAtXkSP1QTNp4eSD34Zh6/Jfni1Q=
# ListenPort = 51820
# DNS = 10.6.210.1, pfSense.home.arpa
# Address = 10.6.210.2/24
#
# [Peer]
# PublicKey = PUVBJ+zuz/0mRPEB4tIaVbet5NzVwdWMX7crGx+/wDs=
# AllowedIPs = 0.0.0.0/0
# Endpoint = 198.51.100.6:51820

# This script generates new wg config files for clients to connect to my server.
# This is from the clients perspective, so the interface is the remote device, and the peer is this server.

# Generates example values instead of using real values
set is_debug_mode test "$argv[1]" = --debug

function gen_private_key
    wg genkey
end

function gen_public_key
    set -l private $argv[1]
    echo $private | wg pubkey
end

function gen_key_pair
    set -l private (gen_private_key)
    set -l public (gen_public_key $private)
    echo $private
    echo $public
end

function get_peer_public_key
    if $is_debug_mode
        echo (gen_public_key (gen_private_key))
    else
        echo (gen_public_key (cat "/run/secrets/wireguard/server"))
    end
end

set interface_key_pair (gen_key_pair)
set address "10.100.0.<n>/32"
set dns "192.168.0.165"

set peer_public_key (get_peer_public_key)
set endpoint "66.208.98.226:47000"
set allowed_ips "0.0.0.0/0"
