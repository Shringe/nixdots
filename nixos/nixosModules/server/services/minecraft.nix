{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.server.services.minecraft;

  domain = config.nixosModules.reverseProxy.domain;
in
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  options.nixosModules.server.services.minecraft = {
    enable = mkOption {
      type = types.bool;
      # default = config.nixosModules.server.services.enable;
      default = false;
    };

    host = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 25565;
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://mc.${domain}";
    };
  };

  config = mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;

      # Uncomment for debugging
      # managementSystem.systemd-socket.enable = true;

      servers.school3 = {
        enable = true;
        openFirewall = true;
        package = pkgs.fabricServers.fabric-1_21_8;

        whitelist = {
          "Shringe_" = "b55a654f-3cf8-40f7-a39c-b68e5a261fad";
        };

        serverProperties = {
          server-port = cfg.port;
          difficulty = "hard";
          gamemode = "survival";
        };

        symlinks.mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            forgeconfigapiport = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ohNO6lps/versions/Bogviccn/ForgeConfigAPIPort-v21.8.0-1.21.8-Fabric.jar";
              sha512 = "622f894586683a959355487161fc6b95221fbfaef3c4f24752a402e7d599336a85e5d332bea78ad173df2c8cf8dce2e9b99af3974df0cf1c559f43d9fc02c29b";
            };
            puzzleslib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/QAGBst4M/versions/sYuwlGfN/PuzzlesLib-v21.8.6-1.21.8-Fabric.jar";
              sha512 = "dafda0b46f32f23c3b672c134d4d6409643238e703d541ce07717267643e4fe7346393e7d1f3ea583de7c7f4c2c5e55cf8d3af11470a5591f0cac4736ecbfdb0";
            };
            collective = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/mld0ZPD9/collective-1.21.8-8.4.jar";
              sha512 = "ef5fc74d45e6528fd3a358bff1ad038ace3cda1a3cd20ac91fe8a5215c39ca51f6d1e2c63f04df4bdb5c44d7798233cf6e71c03737badf677357f0a8f2bddcc9";
            };
            cristellib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/cl223EMc/versions/bgdjh4pG/cristellib-fabric-2.0.3.jar";
              sha512 = "34f4ea99fdc71c3ed3faa2df26d8a5cffd4a68318e1bbcd9943c98d2089fe1f36f31b938487576e3538896f3cb2c35c601432850b086a57e6689c6188534d1fe";
            };
            scalablelux = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/PQLHDg2Q/ScalableLux-0.1.5%2Bfabric.e4acdcb-all.jar";
              sha512 = "ec8fabc3bf991fbcbe064c1e97ded3e70f145a87e436056241cbb1e14c57ea9f59ef312f24c205160ccbda43f693e05d652b7f19aa71f730caec3bb5f7f7820a";
            };
            lithium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/pDfTqezk/lithium-fabric-0.18.0%2Bmc1.21.8.jar";
              sha512 = "6c69950760f48ef88f0c5871e61029b59af03ab5ed9b002b6a470d7adfdf26f0b875dcd360b664e897291002530981c20e0b2890fb889f29ecdaa007f885100f";
            };
            fabric-api = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/jjBL6OsN/fabric-api-0.132.0%2B1.21.8.jar";
              sha512 = "af781f8e06b1fff86c0b7055c9e696552555d5fbc71298447f816689756fe598b2ced182fbf6687c9457472352118e5052fa66de116e7a818584fd8f6e523a7d";
            };
            # c2me = pkgs.fetchurl {
            #   url = "https://cdn.modrinth.com/data/VSNURh3q/versions/tlZRTK1v/c2me-fabric-mc1.21.8-0.3.4.0.0.jar";
            #   sha512 = "30cbc520cb8349036d55a1cb1f26964cf02410cf6d6a561d9cc07164d7566a3a7564367de62510f2bab50723c2c7c401718001153fa833560634ce4b2e212767";
            # }; # Needs jdk22
            ferritecore = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uXXizFIs/versions/CtMpt7Jr/ferritecore-8.0.0-fabric.jar";
              sha512 = "131b82d1d366f0966435bfcb38c362d604d68ecf30c106d31a6261bfc868ca3a82425bb3faebaa2e5ea17d8eed5c92843810eb2df4790f2f8b1e6c1bdc9b7745";
            };
            appleskin = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/YAjCkZ29/appleskin-fabric-mc1.21.6-3.0.6.jar";
              sha512 = "e36c78b036676b3fac1ec3edefdcf014ccde8ce65fd3e9c1c2f9a7bbc7c94185168a2cd6c8c27564e9204cd892bfbaae9989830d1acea83e6f37187b7a43ad7d";
            };
            nochatreports = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/LhwpK0O6/NoChatReports-FABRIC-1.21.7-v2.14.0.jar";
              sha512 = "6e93c822e606ad12cb650801be1b3f39fcd2fef64a9bb905f357eb01a28451afddb3a6cadb39c112463519df0a07b9ff374d39223e9bf189aee7e7182077a7ae";
            };
            distanthorizons = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uCdwusMi/versions/9yaYzpcr/DistantHorizons-2.3.4-b-1.21.8-fabric-neoforge.jar";
              sha512 = "593b16b03917d9385eb275ace9505e27a954043e834425c1b50e8347f427bd85a0f00403e2b6eba20634fe6b7019d31218b849a807116cbe1115bbf81e320440";
            };
            towns-and-towers = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/DjLobEOy/versions/HEqgNPcC/t_and_t-fabric-neoforge-1.13.5.jar";
              sha512 = "c3e706f399792db2a8baa1426f44390b936b7221ac7757fa0a9cf3cb04bb4b1f5aeb94d491e1c9fea8a62238d59ae08f29c65746628ff7e96171ad17c5a007d2";
            };
            terralith = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/8oi3bsk5/versions/o7SunBER/Terralith_1.21.5_v2.5.11.zip";
              sha512 = "c45fa28d8c7a739ee3791eea6c64a8500e5a2501b84c5267dca90b3484b7db9d39f79c723ecfae320d994036950304d15db40f28c12c58e14045a95f51e22bf8";
            };
            doubledoors = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/JrvR9OHr/versions/Kaxph4k0/doubledoors-1.21.8-7.1.jar";
              sha512 = "09370159d41925eec07558e65cf06cff99253503d55ff13b206bae1f2914c4e8cdab938747526e3e75f900793fa95eaf2636e7eead1f4bdfc9b0d9efeacfc50e";
            };
            # leavesbegone = pkgs.fetchurl {
            #   url = "https://cdn.modrinth.com/data/AVq17PqV/versions/mOo6anJy/LeavesBeGone-v21.8.0-1.21.8-Fabric.jar";
            #   sha512 = "b4647db4556854562a0756c90a6ab5fde2957a1fa6ff829afcc95610275dad894c0fcd8ac3adaafc1d11acf012d9d54b96a73cbf9875c95b350b15ce3f4bde38";
            # };
            fallingtree = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Fb4jn8m6/versions/vs4XSgGN/FallingTree-1.21.8-1.21.8.2.jar";
              sha512 = "c3a12bc095fdd603b6bcd972772a937a0d6ce8b3bece81d1b4bc2cb45de7d6d5d4fabbe056f26ebe04f8052a92e3c62618b7b97767bd673abccb3f310e3ac457";
            };
            tpautilities = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/4Eg1Wjr2/versions/YG7I089P/tpa-utilities-1.2.0.jar";
              sha512 = "30166a0af5092814f45f1cc4a5a7ad73f280192275fcd9830a4644e9b125127393ddeabc80090cf2349344308f818cc7d8a1f3c86e9461de900b5cc648632fce";
            };
            neutralanimals = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/w1AXlLHd/versions/LMrA12LJ/neutral-animals-1.2.14.jar";
              sha512 = "0eb157b92e4dac71c1924de4cf320012e0b5b46066df79251b188767689b6389a8261fdf25e907e513d023bd4203ea03d78d74f4498493a1b38f4ce9ebed6118";
            };
            singlesleepmod = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/HzlME0ff/versions/WKBhdN3D/single-sleep-mod-1.0.0.jar";
              sha512 = "ded132e80deea64d13b594dc84ec321228d5317014bd3f54198fb6b2973588d6df152f1adb6ba36b8d9a8fd37d681f2efd1166b5a7c91b8b0770c7538b7434cf";
            };
            milkallthemobs = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/qRidloO4/versions/xUlMtm0h/milkallthemobs-1.21.8-3.4.jar";
              sha512 = "ac5501416a773f4f40a8717f4a622a94d699262123f0897cebfbb7cbe67680d5b424689f83f05e7bd89d2399939b173c1ea2f66c2ab203d2eccf99ffdf892976";
            };
            fabric-language-kotlin = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/Y91MRWtG/fabric-language-kotlin-1.13.5%2Bkotlin.2.2.10.jar";
              sha512 = "bae89ea5e71895f5a760def61359bb90a715832d998aec8141902410c503533fc42631e033109fcc9cdb3f869c58da9b89e9efc3b3ef112cbafe27059de9239e";
            };
            owolib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ccKDOlHs/versions/fboVuDvC/owo-lib-0.12.22%2B1.21.8.jar";
              sha512 = "606d327fdd8089de1a02f3654188cb76da79c0f1df8728d679e64b740fac5db6920f8c1c15d3c2a782a3e96ec63207587a9a3982226d197aceb5c8f4bd24db71";
            };
            fromthefog = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/p1WH6sHr/versions/7p2yqbTn/From-The-Fog-Forge-Fabric-1.21.6-1.21.8-v1.10.3.jar";
              sha512 = "7d185dc1c50a6fe9f075f3f2fdb4c1d27207f1f605a6be9bf72e13e4cd394313a50d908c016e7332bef9ce9625340f3a42675c147cf69495af30a0c17f890a57";
            };
            # distantfriends = pkgs.fetchurl { # Needs client mod
            #   url = "https://cdn.modrinth.com/data/CDaJ8xGu/versions/8mMzt1FR/DistantFriends-fabric-1.21.8-0.12.0.jar";
            #   sha512 = "08f1a2f4f5206131f52034a3f3a29d308b67dfb9aa0adb9f6558bb1337d81531fd3af2ef3584e629050578b1a977fe06e2e992782483275d27779cfb1e6909c9";
            # };
            homeutilities = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/CLpHljll/versions/imMefwZH/home-utilities-1.3.0.jar";
              sha512 = "3ebd798a102beb82d08a8173c003dd99384d05302785a26e04dff0445a137767aa31218524a47da3d8e03a265daa62439ef2849ee98bf1a2ab8ed8542ee8d46d";
            };
          }
        );

        jvmOpts = "-Xmx4G -Xms4G -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseNUMA -XX:NmethodSweepActivity=1 -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M -XX:-DontCompileHugeMethods -XX:MaxNodeLimit=240000 -XX:NodeLimitFudgeFactor=8000 -XX:+UseVectorCmov -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority -XX:ThreadPriorityPolicy=1 -XX:AllocatePrefetchStyle=3  -XX:+UseG1GC -XX:MaxGCPauseMillis=37 -XX:+PerfDisableSharedMem -XX:G1HeapRegionSize=16M -XX:G1NewSizePercent=23 -XX:G1ReservePercent=20 -XX:SurvivorRatio=32 -XX:G1MixedGCCountTarget=3 -XX:G1HeapWastePercent=20 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1RSetUpdatingPauseTimePercent=0 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5.0 -XX:G1ConcRSHotCardLimit=16 -XX:G1ConcRefinementServiceIntervalMillis=150 -XX:GCTimeRatio=99 -XX:+UseLargePages -XX:LargePageSizeInBytes=2m";
      };
    };
  };
}
