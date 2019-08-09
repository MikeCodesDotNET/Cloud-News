module.exports = {
    title: 'Azure News - Dev Guide',
    description: 'Swift & Azure sample guide',
    themeConfig: {
        nav: [
          { text: 'Github', link: 'https://github.com/mikecodesdotnet/azure-news/' },
          { text: 'Blog', link: 'https://mikecodes.net' },

        ],
        displayAllHeaders: true, // Default: false
        sidebar: [
            {
                title: 'Introduction',
                collapsable: false,
                children: [
                  '/App/README.md'
                ]
              },
              {
                title: 'The App',
                children: [ /* ... */ ]
              },
              {
                title: 'The Backend',
                children: [ /* ... */ ]
              }
          ]
      }
  }