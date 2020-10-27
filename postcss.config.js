const production = process.env.NODE_ENV === 'production'

const purgecss = require('@fullhuman/postcss-purgecss')({
  content: ['./app/**/*.html.erb', './app/**/*.slim', './app/**/*.svelte'],

  whitelistPatterns: [/svelte-/],

  defaultExtractor: (content) => content.match(/[A-Za-z0-9-_:/]+/g) || [],
})

module.exports = {
  plugins: [
    require('postcss-import')(),
    require('tailwindcss')(),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009',
      },
      stage: 3,
    }),
    ...(production ? [purgecss] : []),
  ],
}
