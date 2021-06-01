# instalando pacote binancer no colab!
# install.packages("remotes")
# remotes::install_github("daroczig/binancer")

# instalando pacote readr, para operações com arquivos CSV
install.packages('readr')


# carregando libs
library(binancer)
library(readr)



# criando o frame que vai compor o lago btcusd
btcusddata <- data.frame(binance_klines('BTCUSDT', interval = '1m'))

# exibindo a estrutura do lago
str(btcusddata)

write.csv(btcusddata, file="btcusddata.csv")

# TO DO:
#[0]- get crypto data
#[1]- save dataframe to drive
# 1.5 - commit to github  
# 2 - auto feed the lake with constant data
# 3 - data wrangling of the lake
# 4 - apply candlestick analysis
# 5 - apply candlestick short/long-term crossing analysis
# 6 - save news aggregation
# 7 - save social media sentimental analysis
# 4 - test models
# 5 - * - weigh other variables to impprove prediction (social media trends aggregator, news aggregator, sentimental analysis in social mediaetc)