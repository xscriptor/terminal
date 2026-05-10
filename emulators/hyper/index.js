const THEMES = {
  x: require('./themes/x'),
  madrid: require('./themes/madrid'),
  lahabana: require('./themes/lahabana'),
  seul: require('./themes/seul'),
  miami: require('./themes/miami'),
  paris: require('./themes/paris'),
  tokio: require('./themes/tokio'),
  oslo: require('./themes/oslo'),
  helsinki: require('./themes/helsinki'),
  berlin: require('./themes/berlin'),
  london: require('./themes/london'),
  praha: require('./themes/praha'),
  bogota: require('./themes/bogota')
}

module.exports.decorateConfig = (config) => {
  const key =
    (config && config.xscriptorTheme) ||
    process.env.XSCRIPTOR_HYPER_THEME ||
    'x'
  const theme = THEMES[key] || THEMES['x']
  return Object.assign({}, config, theme)
}

module.exports.themes = Object.keys(THEMES)
