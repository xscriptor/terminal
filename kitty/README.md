# Customizations for kitty terminal


Themes Available

- [Xscriptor Theme](./xscriptor-theme/README.md)
- [Xtropicalneon](./themes/xtropicalneon/README.md)


## Installation Instructions

1. **Create the themes directory (if it doesn't exist):**

```bash
mkdir -p ~/.config/kitty/themes
```

2. **Download the theme of your choice (change the name as needed)**


```bash
curl -o ~/.config/kitty/themes/xtropicalneon/kitty.conf https://raw.githubusercontent.com/xscriptorcode/art/main/themes/xtropicalneon/kitty.conf

```

3. Include the theme in your main Kitty config or past the content:

Edit ~/.config/kitty/kitty.conf and include one of the themes:

```bash
include themes/xtropicalneon/kitty.conf
```

or just type:
```bash
echo "include themes/xtropicalneon/kitty.conf" >> ~/.config/kitty/kitty.conf
```