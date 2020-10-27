const createPreprocessors = require('../../../svelte.config')
  .createPreprocessors

const production = process.env.NODE_ENV === 'production'

module.exports = {
  test: /\.svelte(\.erb)?$/,
  use: [
    {
      loader: 'svelte-loader',
      options: {
        hotReload: false,
        emitCss: true,
        preprocess: createPreprocessors(production),
      },
    },
  ],
}
