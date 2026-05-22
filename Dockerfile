# --- Etapa 1: Construcción y dependencias (Builder) ---
FROM node:18-alpine AS builder

# Definir el directorio de trabajo
WORKDIR /app

# Copiar los archivos de configuración de dependencias
COPY package*.json ./

# Instalar todas las dependencias necesarias
RUN npm install

# --- Etapa 2: Entorno de ejecución ligero para Producción ---
FROM node:18-alpine AS production

WORKDIR /app

# Configurar variables de entorno óptimas para producción
ENV NODE_ENV=production
ENV PORT=3000

# Copiar únicamente la carpeta node_modules construida en la Etapa 1
COPY --from=builder /app/node_modules ./node_modules

# Copiar el código fuente mínimo necesario para que funcione la API
COPY package*.json ./
COPY server.js ./

# CUMPLIMIENTO IE1 (SEGURIDAD): Cambiar el propietario de los archivos al usuario 'node'
# El usuario 'node' ya viene creado por defecto en las imágenes alpine de Node.js
RUN chown -R node:node /app

# Forzar a Docker a ejecutar la aplicación con este usuario seguro (No-Root)
USER node

# Exponer el puerto en el que escucha Express según tu documentación
EXPOSE 3000

# Comando para arrancar la aplicación en producción
CMD ["node", "server.js"]
