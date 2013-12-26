T.def 'menu', (config) ->
  T.each 'sub-menu', config.menu, config

T.def 'sub-menu', (menuConfig, config) ->
  [ 'li'
    class: menuConfig.type
    [ 'a'
      href: 'javascript:void(0)'
      menuConfig.label
    ]
    if menuConfig.children
      [ 'ul'
        T.each('menu-item', menuConfig.children, menuConfig.type, config)
      ]
  ]

T.def 'menu-item', (item, type, config) ->
  url   = if item.url then item.url else "#/#{type}/#{item.player}"
  label = if item.label then item.label else "#{config.players[item.player].name}"
  [ 'li'
    [ 'a'
      href: url
      label
    ]
  ]

T('menu', @siteConfig).render inside: '#nav'

