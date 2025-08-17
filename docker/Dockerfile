FROM nginx:alpine

# Copia a configuração para o diretório correto do Nginx
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Copia os arquivos HTML para o diretório padrão do Nginx
COPY nginx/html/ /usr/share/nginx/html/
