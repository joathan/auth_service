#!/bin/bash
set -e

echo "Iniciando o script de entrada..."

# Verifica se as gems estão instaladas
echo "Verificando gems..."
bundle check || bundle install

# Verifica se o banco de dados já existe
bundle exec rails db:create

# Executa as migrações
echo "Aplicando migrações..."
bundle exec rails db:migrate

# Inicia o servidor
echo "Iniciando o processo principal..."
rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'

exec "$@"
