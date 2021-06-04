---
title: "RAILS plot: btc x usd from binance - btcusdbinance"
author: "Daniel Benicio"
date: "01/06/2021"
output: html_document
---

### OBS: RENOMEAR ESTE ARQUIVO PARA EXTENSÃO .Rmd PARA RODAR NO R Studio!

# Introdução 

**R**

**A**rtificial

**I**ntelligence

**L**eveling

**S**ystem


Este é o sistema de nivelamento com inteligência artificial baseado em R para análises de alguns ativos do mercado financeiro. O objetivo do nivelamento é habilitar qualquer pessoa para negociação eficiente com demais players do mercado com maior conhecimento técnico, e futuramente servir de apoio para análises de swing trading, determinadas por uma margem pré-definida para alertas, indicadas pelo programa cruzando dados de 2 médias móveis exponenciais, sendo uma de período curto (7 a 17 candle sticks) e uma de período longo (entre 14 e 34 candles) para identificação da expectativa de altas. Ainda, a ideia é correlacionar esta estratégia com news aggregation e social media sentimental analysis para identificação da expectativa de baixas.

Caso os termos acima não façam sentido para você, é extremamente aconselhável não usar este código, mas entender os conceitos de economia e estatística mencionados anteriormente antes de qualquer coisa. Além disso, este código está sendo construído com licença Creative Commons `CC BY-NC`, disponível junto com o código neste documento [License](./LICENSE), ou seja, o software é fornecido _"AS IS"_, "como está", sem garantia de qualquer tipo, e disponível para usos comuns como "remixar", adaptar e desenvolver seu trabalho não comercialmente e, seus derivados também devem manter os créditos das respectivas porções de códigos e não serem comerciais, mantendo junto ao software o arquivo da licença original. 


# Funcionamento

1. O script em R será executado conforme uma rotina de agendamento
2. Primeiramente ele busca os últimos dados do pregão do ativo para o dataframe df
3. Em seguida ele concatena as bases btcusdbinance (carregada de btcusdbinance.csv) e df na base df 
3. Então ele salva a base em btcusdbinance.csv
... CONTINUAR DESCRIÇÃO ...

Para visão dos próximos passos a serem implementados, ver o ` To DO` ao final deste documento.


Atenção para a libs necessárias de instalação comentadas no bloco a seguir. E além de carregar as libs, o bloco abaixo também declara algumas variáveis importantes para execução da rotina.

```{r}
# instalando pacote binancer no colab!
# install.packages("remotes")
# remotes::install_github("daroczig/binancer")

# instalando pacote readr, para operações com arquivos CSV
# install.packages('readr')

# instalando pacote tidyquant, para plotar em candlesticks
# install.packages('tidyquant')

# carregando libs
library(binancer)
library(readr)
library(ggplot2)
library(tidyquant)
library(quantmod)

# variáveis
alpha_param <- TRUE
title_param <- "BTC/USD - Binance"
```

Atualizando a base com dados novos (últimos 10 a 5 minutos atrás) concatenados à última base válida:

```{r}


# criando o frame que vai ser adicionado a base
df <- data.frame(binance_klines('BTCUSDT', interval = '5m',
                                
    start_time = round(as.POSIXct(Sys.time()) - 
        as.difftime(10, units="mins"),"mins"),
    
    end_time = round(as.POSIXct(Sys.time()) - 
        as.difftime(5, units="mins"),"mins")) )


# carregando última base válida
btcusdbinance <- read_delim(file = "btcusdbinance.csv",
                         delim = ",", 
                         escape_double = FALSE, 
                         trim_ws = TRUE)

# concatenando as duas bases
df <- rbind(btcusdbinance, df)

# Atualizando a base
write.csv(df, file="btcusdbinance.csv", row.names=FALSE)


# exibindo a estrutura da base
# str(df)
  
df$Date <- df$close_time
df$Close <- df$close 
df$Open <- df$open 
df$Low <- df$low 
df$High <- df$high 

df$change <- ifelse(df$close > df$open, "up", ifelse(df$close < df$open, "down", "flat"))
  

  # originally the width of the bars was calculated by FXQuantTrader with use of 'periodicity()', which 
  # seems to work ok only with: ‘minute’,‘hourly’, ‘daily’,‘weekly’, ‘monthly’,
  # ‘quarterly’, and ‘yearly’, but can not do 1 sec bars while we want arbitrary bar size support!-)
  # df$width <- as.numeric(periodicity(df)[1])
  # So let us instead find delta (seconds) between 1st and 2nd row and just 
  # use it for all other rows. We check 1st 3 rows to avoid larger "weekend gaps"
  width_candidates <- c(as.numeric(difftime(df$Date[2], df$Date[1]), units = "secs"), 
                        as.numeric(difftime(df$Date[3], df$Date[2]), units = "secs"), 
                        as.numeric(difftime(df$Date[4], df$Date[3]), units = "secs"))

  df$width_s = min(width_candidates)  # one (same) candle width (in seconds) for all the bars

  # define the vector of candle colours either by name or by rgb()
  #candle_colors = c("down" = "red", "up" = "green", "flat" = "blue")
  candle_colors = c("down" = rgb(192,0,0,alpha=255,maxColorValue=255), "up" = rgb(0,192,0,alpha=255,maxColorValue=255), "flat" = rgb(0,0,192,alpha=255,maxColorValue=255))

  # Candle chart:
  g <- ggplot(df, aes(x=Date))+
    geom_linerange(aes(ymin=Low, ymax=High, colour = change), alpha = alpha_param) +  # candle whiskerss (vertical thin lines:)
    theme_bw() +
    labs(title=title_param) +
    geom_rect(aes(xmin = Date - width_s/2 * 0.9, xmax = Date + width_s/2 * 0.9, ymin = pmin(Open, Close), ymax = pmax(Open, Close), fill = change), alpha = alpha_param) +                            # cabdke body
    guides(fill = FALSE, colour = FALSE) +
    scale_color_manual(values = candle_colors) +  # color for line
    scale_fill_manual(values = candle_colors)     # color for candle fill  

    # Handle special cases: flat bar and Open == close:
    if (any(df$change == "flat")) g <- g + geom_segment(data = df[df$change == "flat",], aes(x = Date - width_s / 2 * 0.9, y = Close, yend = Close, xend = Date + width_s / 2 * 0.9, colour = change), alpha = alpha_param)

  #print(g)
  g




```



#### TO DO:

0. ~~get crypto data~~
1. ~~save dataframe to drive~~
2. ~~commit to github~~
3. ~~plot candlesticks~~
4. auto feed the lake with constant concatenated data
    * ~~concatenate files~~
    * ~~pull small range of time from new trades~~
        * ~~bug: time range inconsistence in close. observed in 1 minute interval.~~
    * automate
5. data wrangling of the lake
6. apply candlestick short/long-term crossing analysis
7. include other assets (eth, doge, fii, usd, acn)
8. save news aggregation
9. save social media sentimental analysis
10. test models
11. weigh other variables to impprove prediction (social media trends aggregator, news aggregator, sentimental analysis in social mediaetc)
