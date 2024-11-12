# Definir a imagem base do Ruby 3.3.0
FROM ruby:3.3.0

# Instalar dependências do sistema necessárias para Nokogiri e MySQL
RUN apt-get update -qq && apt-get install -y build-essential libxml2-dev libxslt1-dev default-libmysqlclient-dev

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instalar as gems sem usar versões binárias específicas
RUN bundle config set force_ruby_platform true
RUN bundle install

# Copiar o restante da aplicação
COPY . .

# Expor a porta da aplicação
EXPOSE 3000

# Comando para iniciar o servidor
CMD ["rails", "server", "-b", "0.0.0.0"]
