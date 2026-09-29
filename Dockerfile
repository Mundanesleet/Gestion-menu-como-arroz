# ==============================================================================
# Dockerfile para Como-arroz (Django)
#
# Un Dockerfile es una RECETA: una lista de pasos que construyen una "imagen"
# (una caja con tu app + todo lo que necesita para correr). Docker ejecuta
# cada línea en orden, una sola vez, y cachea el resultado de cada paso.
# ==============================================================================

# 1. Imagen base: Python 3.11 ya instalado, versión "slim" (más liviana que
#    la imagen completa, sin herramientas que no necesitamos).
FROM python:3.11-slim

# 2. Variables de entorno recomendadas para Python dentro de un contenedor:
#    - No genera archivos .pyc (no sirven de nada en un contenedor desechable)
#    - No hace buffer de los logs, para que aparezcan en tiempo real
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Carpeta de trabajo DENTRO del contenedor. Todo lo que sigue pasa aquí.
WORKDIR /app

# 4. Copiamos SOLO requirements.txt primero (no todo el código todavía).
#    Truco importante: Docker cachea cada paso. Si no cambias requirements.txt,
#    Docker reutiliza esta capa y no reinstala nada — mucho más rápido en
#    reconstrucciones. Si copiáramos todo el código antes de instalar,
#    cualquier cambio de código invalidaría también el caché de instalación.
COPY requirements.txt .

# 5. Instala las dependencias de Python dentro del contenedor
RUN pip install --no-cache-dir -r requirements.txt

# 6. AHORA sí copiamos el resto del código del proyecto
COPY . .

# 7. Puerto que la app usa DENTRO del contenedor (documentación, no lo publica
#    por sí solo — eso lo hace docker-compose.yml o `docker run -p`)
EXPOSE 8000

# 8. Comando que se ejecuta cuando el contenedor arranca.
#    NOTA: `runserver` es solo para desarrollo/práctica local. En producción
#    real se usaría gunicorn, pero para aprender Docker esto es suficiente.
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
