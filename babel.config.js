module.exports = api => {
  const env = api.cache(() => process.env.NODE_ENV)
  console.log(env)
  return {
    presets: [
      [
        require('@babel/preset-env').default,
        {
          forceAllTransforms: true,
          useBuiltIns: 'entry',
          modules: false,
        },
      ],
      '@babel/react',
    ],
    plugins: [],
  }
}
