# instalando pacote binancer no colab!
install.packages("remotes")
remotes::install_github("daroczig/binancer")

# carregando lib
library(binancer)

# criando o frame que vai compor o lago btcusd
btcusdlake <- data.frame(binance_klines('BTCUSDT', interval = '1m'))

# exibindo a estrutura do lago
str(btcusdlake)

# TO DO:
# 1 - save frame to drive
# 2 - auto feed the lake in google drive with constant data
# 3 - data wrangling of the lake
# 4 - test models
# 5 - * - weigh other variables to impprove prediction (social media trends aggregator, news aggregator, sentimental analysis in social mediaetc)