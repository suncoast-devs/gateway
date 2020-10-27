const sveltePreprocess = require('svelte-preprocess')

function createPreprocessors(production) {
  return sveltePreprocess({
    sourceMap: !production,
    postcss: true,
  })
}

module.exports = {
  preprocess: createPreprocessors(true),
  createPreprocessors,
}
