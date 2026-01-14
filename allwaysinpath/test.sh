find . -name '*.csproj' | xargs -I {} sed -i 's/<Nullable>annotations<\/Nullable>/<Nullable>enable<\/Nullable>/' {}
