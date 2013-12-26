bigFour = 'novak_djokovic,roger_federer,rafael_nadal,andy_murray'

@siteConfig =
  players:
    roger_federer:
      name: 'Roger Federer'
    rafael_nadal:
      name: 'Rafael Nadal'
    novak_djokovic:
      name: 'Novak Djokovic'
    andy_murray:
      name: 'Andy Murray'
  menu:
    [
      type: 'rankings'
      label: 'Rankings'
      url: '#/rankings'
    ,
      type: 'players'
      label: 'Players'
      children:
        [
          player: 'roger_federer'
        ,
          player: 'rafael_nadal'
        ]
    ,
      type: 'rank-history'
      label: 'Rank History'
      children:
        [
          label: 'BIG FOUR'
          url: "#/rank-history/#{bigFour}"
        ,
          player: 'roger_federer'
        ]
    ,
      type: 'win-loss'
      label: 'Win/Loss'
      children:
        [
          label: 'BIG FOUR'
          url: "#/win-loss/#{bigFour}"
        ,
          player: 'roger_federer'
        ]
    ,
      type: 'schedule'
      label: 'schedule'
      children:
        [
          label: 'Tournaments'
          url: "#/tournaments"
        ,
          player: 'roger_federer'
        ]
    ,
      type: 'support'
      label: 'Support'
      url: 'support.html'
    ]

