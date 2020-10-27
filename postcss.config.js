const production = process.env.NODE_ENV === 'production'

const purgecss = require('@fullhuman/postcss-purgecss')({
  content: ['./src/**/*.html', './src/**/*.svelte'],

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
