# #!/bin/zsh

# # ios helpers

# // TODO split into iphone, ipad, etc
# declare -A __IOS_ICON_SET=(
#     [$((20 * 1))]=20x20@1x
#     [$((20 * 2))]=20x20@2x
#     [$((20 * 3))]=20x20@3x
#     [$((29 * 1))]=29x29@1x
#     [$((29 * 2))]=29x29@2x
#     [$((29 * 3))]=29x29@3x
#     [$((40 * 1))]=40x40@1x
#     [$((40 * 2))]=40x40@2x
#     [$((40 * 3))]=40x40@3x
#     [$((60 * 2))]=60x60@2x
#     [$((60 * 3))]=60x60@3x
#     [$((76 * 1))]=76x76@1x
#     [$((76 * 2))]=76x76@2x
#     [$((83.5 * 2))]=83.5x83.5@2x
#     [$((1024 * 1))]=1024x1024@1x
# )

# # make ios icon set from seed image
# function ios.generate-icon-set() {
#     local seed_image="$1"
#     local output_file_prefix="${2:=Icon-App-}"

#     if [ -z "$seed_image" ] ; then
#         echo "Usage: ios.generate-icon-set filename [output-file-prefix]" 2>&1
#         return 1
#     fi

#     for key value in ${(kv)__IOS_ICON_SET} ; do
#         echo "$key -> $value"
#         gm convert icon.png -resize "40x40x!" icon_40.png
#     done
# }
