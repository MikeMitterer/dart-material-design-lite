Basis für SS:
    847 x 656 ( Dart-Playground settings)

    900 x 507

wsk-card-img-container:
    330 x 186 (1,774)

ImageMagick
    convert bottombar.png -resize 300x bottombar-300.png

    find . -regex './[a-z0-9A-Z]*\.png'
        mogrify -resize 300x -set filename:name "%t-300.%e" -write "%[filename:name]" bottombar.png

    find . -regex './[a-z0-9A-Z]*\.png' -exec mogrify -resize 300x -set filename:name "%t-300.%e" -write "%[filename:name]" {} \;
    find example/_images -regex '.*/[a-z0-9A-Z]*\.png' -exec mogrify -resize 300x -set filename:name "%t-300.%e" -write "example/_images/%[filename:name]" {} \;
