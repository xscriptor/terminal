const THEMES = {
  x: require('./themes/xscriptor-theme'),
  xmadrid: require('./themes/xscriptor-theme-light'),
  xlahabana: require('./themes/x-retro'),
  'x-dark-one': require('./themes/x-dark-one'),
  xseul: require('./themes/x-dark-candy'),
  xmiami: require('./themes/x-candy-pop'),
  xparis: require('./themes/x-sense'),
  xtokio: require('./themes/x-summer-night'),
  xoslo: require('./themes/x-nord'),
  xhelsinki: require('./themes/x-nord-inverted'),
  xberlin: require('./themes/x-greyscale'),
  xlondon: require('./themes/x-greyscale-inverted'),
  xpraga: require('./themes/x-dark-colors'),
  xbogota: require('./themes/x-persecution')
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
