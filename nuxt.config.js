
const professions = require('./static/pixel-people/professions.json')
const specialGenes = require('./static/pixel-people/special-genes.json')

export default {
  head: {
    title: 'rwampler Sandbox',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: process.env.npm_package_description || '' }
    ],
    link: [
      //{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=VT323&display=swap' }
    ]
  },
  loading: { color: '#000' },
  render: {
    resourceHints: false
  },
  generate: {
    fallback: false
  },
  env: {
    PROFESSIONS: professions,
    SPECIAL_GENES: specialGenes
  },
  telemetry: false,
  target: 'static',
  build: {
    // analyze: true,
    publicPath: '/assets/',
    splitChunks: {
      layouts: true
    },
    transpile: ['animejs', 'three'],
    babel: {
      plugins: [
        ['@babel/plugin-proposal-private-methods', { loose: true }]
      ]
    },
    postcss: {
      plugins: {
        'postcss-preset-env': {
          browserslist: ["> 1%", "last 2 versions"],
          features: {
            customProperties: false
          }
        },
        'postcss-import': {}
      }
    },
    extend (config, { isDev, isClient, isServer }) {
      config.module.rules.push({
        test: /\.coffee$/,
        use: 'coffee-loader',
        exclude: /(node_modules)/
      });
    }
  },
  buildModules: [
    '@nuxtjs/moment'
  ],
  plugins: [
    { src: '~/plugins/element-queries', ssr: false },
    { src: '~/plugins/three', ssr: false },
    { src: '~/plugins/iasip/echarts', ssr: false },
    { src: '~/plugins/iasip/flaticon-license', ssr: false },
    { src: '~/plugins/iasip/font-awesome', ssr: false }
  ]
}
