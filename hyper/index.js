const THEMES = {
  'xscriptor-theme': require('./themes/xscriptor-theme'),
  'xscriptor-theme-light': require('./themes/xscriptor-theme-light'),
  'x-retro': require('./themes/x-retro'),
  'x-dark-one': require('./themes/x-dark-one'),
  'x-candy-pop': require('./themes/x-candy-pop'),
  'x-sense': require('./themes/x-sense'),
  'x-summer-night': require('./themes/x-summer-night'),
  'x-nord': require('./themes/x-nord'),
  'x-nord-inverted': require('./themes/x-nord-inverted'),
  'x-greyscale': require('./themes/x-greyscale'),
  'x-greyscale-inverted': require('./themes/x-greyscale-inverted'),
  'x-dark-colors': require('./themes/x-dark-colors'),
  'x-persecution': require('./themes/x-persecution')
}

module.exports.decorateConfig = (config) => {
  const key =
    (config && config.xscriptorTheme) ||
    process.env.XSCRIPTOR_HYPER_THEME ||
    'xscriptor-theme'
  const theme = THEMES[key] || THEMES['xscriptor-theme']
  return Object.assign({}, config, theme)
}

module.exports.themes = Object.keys(THEMES)
