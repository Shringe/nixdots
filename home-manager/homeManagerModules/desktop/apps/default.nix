{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.apps;

  browsers = [ "zen-twilight.desktop" ];
  text = [ "org.kde.kate.desktop" "neovide.desktop" ];
  images = [ "org.kde.gwenview.desktop" "feh.desktop" ];
  audio = [ "org.kde.elisa.desktop" ];
  video = [ "org.kde.haruna.desktop" "mpv.desktop" ];
in
{
  options.homeManagerModules.desktop.apps = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    # Avoids having to pass -b bac to nh home switch
    # home.file."${config.xdg.dataHome}/mimeapps.list".force = true;
    xdg.configFile."mimeapps.list".force = true;

    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        # Fallbacks
        "application/*"                                                             = [ "org.kde.okular.desktop" "org.pwmt.zathura.desktop" "startcenter.desktop" ];
        "text/*"                                                                    = text;
        "image/*"                                                                   = images;
        "audio/*"                                                                   = audio;  
        "video/*"                                                                   = video; 

        # Web browsers
        "x-scheme-handler/http"                                                     = browsers;
        "x-scheme-handler/https"                                                    = browsers;
        "x-scheme-handler/ftp"                                                      = browsers;
        "x-scheme-handler/chrome"                                                   = browsers;
        "text/html"                                                                 = browsers;
        "application/x-extension-htm"                                               = browsers;
        "application/x-extension-html"                                              = browsers;
        "application/x-extension-shtml"                                             = browsers;
        "application/xhtml+xml"                                                     = browsers;
        "application/x-extension-xhtml"                                             = browsers;
        "application/x-extension-xht"                                               = browsers;

        # Documents
        "application/pdf"                                                           = [ "org.pwmt.zathura.desktop" "okularApplication_pdf.desktop" "org.kde.okular.desktop" ];
        "application/x-pdf"                                                         = [ "org.pwmt.zathura.desktop" "okularApplication_pdf.desktop" "org.kde.okular.desktop" ];
        "application/postscript"                                                    = [ "org.pwmt.zathura.desktop" "org.kde.okular.desktop" ];
        "application/eps"                                                           = [ "org.pwmt.zathura.desktop" "org.kde.okular.desktop" ];
        "image/x-eps"                                                               = [ "org.pwmt.zathura.desktop" "org.kde.okular.desktop" ];

        # Office documents - LibreOffice/Calligra
        "application/vnd.oasis.opendocument.text"                                   = [ "writer.desktop" ];
        "application/vnd.oasis.opendocument.spreadsheet"                            = [ "calc.desktop" ];
        "application/vnd.oasis.opendocument.presentation"                           = [ "impress.desktop" ];
        "application/vnd.oasis.opendocument.graphics"                               = [ "draw.desktop" ];

        # Microsoft Office formats
        "application/msword"                                                        = [ "writer.desktop" ];
        "application/vnd.ms-xpsdocument"                                            = [ "writer.desktop" "okularApplication_xps.desktop" "org.kde.okular.desktop" ];
        "application/vnd.ms-word"                                                   = [ "writer.desktop" ];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"   = [ "writer.desktop" ];
        "application/vnd.ms-excel"                                                  = [ "calc.desktop" ];
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"         = [ "calc.desktop" ];
        "application/vnd.ms-powerpoint"                                             = [ "impress.desktop" ];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = [ "impress.desktop" ];

        # Text files
        "application/rls-services+xml"                                              = text;
        "application/javascript"                                                    = text;
        "application/json"                                                          = text;
        "application/x-shellscript"                                                 = text;
        "application/xml"                                                           = text;

        # Archives
        "application/zip"                                                           = [ "org.kde.ark.desktop" ];
        "application/x-zip"                                                         = [ "org.kde.ark.desktop" ];
        "application/x-zip-compressed"                                              = [ "org.kde.ark.desktop" ];
        "application/x-tar"                                                         = [ "org.kde.ark.desktop" ];
        "application/x-gzip"                                                        = [ "org.kde.ark.desktop" ];
        "application/gzip"                                                          = [ "org.kde.ark.desktop" ];
        "application/x-bzip"                                                        = [ "org.kde.ark.desktop" ];
        "application/x-bzip2"                                                       = [ "org.kde.ark.desktop" ];
        "application/x-xz"                                                          = [ "org.kde.ark.desktop" ];
        "application/x-7z-compressed"                                               = [ "org.kde.ark.desktop" ];
        "application/x-rar"                                                         = [ "org.kde.ark.desktop" ];
        "application/x-rar-compressed"                                              = [ "org.kde.ark.desktop" ];
        "application/vnd.rar"                                                       = [ "org.kde.ark.desktop" ];
        "application/x-compressed-tar"                                              = [ "org.kde.ark.desktop" ];

        # Directories/file manager
        "inode/directory"                                                           = [ "org.kde.dolphin.desktop" "org.wezfurlong.wezterm.desktop" ];

        # Email
        "x-scheme-handler/mailto"                                                   = [ "thunderbird.desktop" ];
        "message/rfc822"                                                            = [ "thunderbird.desktop" ];

        # E-books
        "application/epub+zip"                                                      = [ "okularApplication_epub.desktop" ];
        "application/x-mobipocket-ebook"                                            = [ "okularApplication_mobi.desktop" ];
        "application/vnd.amazon.ebook"                                              = [ "okularApplication_mobi.desktop" ];

        # Disk images
        "application/x-iso9660-image"                                               = [ "org.kde.isoimagewriter.desktop" ];
        "application/x-cd-image"                                                    = [ "org.kde.isoimagewriter.desktop" ];

        # Calendar
        "text/calendar"                                                             = [ "org.kde.korganizer.desktop" ];
        "application/ics"                                                           = [ "org.kde.korganizer.desktop" ];
      };
    };
  };
}
