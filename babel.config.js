module.exports = (api) => {
  const env = api.cache(() => process.env.NODE_ENV)
  return {
    presets: [
      [
        require('@babel/preset-env').default,
        {
          forceAllTransforms: true,
          useBuiltIns: 'entry',
          corejs: '3',
          modules: false,
        },
      ],
    ],
    plugins: [],
  }
}
