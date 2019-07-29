# Markdown Cheat Sheet

Thanks for visiting [The Markdown Guide](https://www.markdownguide.org)!

This Markdown cheat sheet provides a quick overview of all the Markdown syntax elements. It can’t cover every edge case,
so if you need more information about any of these elements, refer to the reference guides for [basic syntax](https://www.markdownguide.org/basic-syntax)
and [extended syntax](https://www.markdownguide.org/extended-syntax).

## Basic Syntax

These are the elements outlined in John Gruber’s original design document. All Markdown applications support these elements.

### Heading

# H1
## H2
### H3

### Bold

**bold text**

### Italic

*italicized text*

### Bold Italic

***italicized text***

### Blockquote

> blockquote

### Nested blockquote

> # header
>
>> nested blockquote
>
> * First item
> * Second item

### Ordered List

1. First item
2. Second item
3. Third item

### Unordered List

- First item
        import sys # code is doubled indentation
        print(type(sys))
- Second item
    This is under list item
- Third item

### Code

`code`

### Fenced Code Block

```json
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
}
```

### Horizontal Rule

---

### Link

[Markdown Guide](https://www.markdownguide.org)

*[Markdown Guide](https://www.markdownguide.org)*

**[Markdown Guide](https://www.markdownguide.org)**

***[Markdown Guide](https://www.markdownguide.org)***

### Link with a title

[Markdown Guide](https://www.markdownguide.org "This is a title")

### Image

![Image](https://www.markdownguide.org/assets/images/tux.png)

![Sized image](https://www.markdownguide.org/assets/images/tux.png =60x50)

[![Image with a link](/assets/images/shiprock.jpg "Shiprock, New Mexico by Beau Rogers")](https://www.flickr.com/photos/beaurogers/31833779864/in/photolist-Qv3rFw-34mt9F-a9Cmfy-5Ha3Zi-9msKdv-o3hgjr-hWpUte-4WMsJ1-KUQ8N-deshUb-vssBD-6CQci6-8AFCiD-zsJWT-nNfsgB-dPDwZJ-bn9JGn-5HtSXY-6CUhAL-a4UTXB-ugPum-KUPSo-fBLNm-6CUmpy-4WMsc9-8a7D3T-83KJev-6CQ2bK-nNusHJ-a78rQH-nw3NvT-7aq2qf-8wwBso-3nNceh-ugSKP-4mh4kh-bbeeqH-a7biME-q3PtTf-brFpgb-cg38zw-bXMZc-nJPELD-f58Lmo-bXMYG-bz8AAi-bxNtNT-bXMYi-bXMY6-bXMYv)

### URLs

<https://www.markdownguide.org>
<fake@example.com>

## Extended Syntax

These elements extend the basic syntax by adding additional features. Not all Markdown applications support these elements.

### Reference

[hobbit-hole reference][1]

[1]: https://en.wikipedia.org/wiki/Hobbit#Lifestyle 'Hobbit lifestyles'

### Table

| Syntax | Description |
| ----------- | ----------- |
| Header | Title |
| Paragraph | Text |

### Footnote

Here's a sentence with a footnote. [^1]

[^1]: This is the footnote.

### Abbreviation

Markdown can be exported to HTML

*[HTML]: HyperText Markup Language

### Heading ID

### My Great Heading {#custom-id}

### Definition List

term
: definition 1
: definition 2

### Strikethrough

~~The world is flat.~~

### Task List

- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media

### Emoji

That is so funny! :joy:

(See also [Copying and Pasting Emoji](https://www.markdownguide.org/extended-syntax/#copying-and-pasting-emoji))

### Highlight

I need to highlight these ==very important words==.

### Subscript and Superscript

H~2~O is a liquid.

2^10^ is 1024.
