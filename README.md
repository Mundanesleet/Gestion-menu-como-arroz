# Como Arroz — CRUD

Backend en Django del menú digital de **Como Arroz** (Pitalito, Huila). Este proyecto administra el catálogo de productos y los pedidos que antes vivían solo en el frontend estático, permitiendo crear, editar y eliminar información desde una base de datos real en lugar de tenerla hardcodeada en el código.

> Es la versión "con backend" del sitio estático de Como Arroz: aquí el menú y los pedidos se guardan y gestionan en base de datos, no en un arreglo de JavaScript.

**En producción:** desplegado en [Render](https://render.com), con base de datos PostgreSQL en [Neon](https://neon.tech) e imágenes almacenadas en [Cloudinary](https://cloudinary.com).

## Tecnologías

- **Python 3** + **Django 5.1.2**
- **PostgreSQL** (vía [Neon](https://neon.tech)) en producción — **SQLite** en desarrollo local por defecto
- **Cloudinary** para almacenamiento de imágenes en producción — disco local en desarrollo
- **Pillow 12.3.0** (manejo de imágenes)
- Plantillas HTML de Django (`templates/`) + CSS/JS propios (`css/`, `js/`, `static/`)
- **Docker** y **docker-compose** para levantar el entorno de desarrollo de forma reproducible

El proyecto está pensado para degradar con gracia: si no configuras `DATABASE_URL` o `CLOUDINARY_URL`, simplemente usa SQLite y disco local — no hace falta tener cuenta en Neon o Cloudinary solo para probar el proyecto.

## Estructura del proyecto

```
Gestion-menu-como-arroz/
├── config/          # Configuración del proyecto Django (settings, urls, wsgi)
├── cuentas/         # App de autenticación (registro / inicio de sesión)
├── menu/            # App CRUD del menú: productos, categorías, precios
├── pedidos/         # App CRUD de pedidos realizados por los clientes
├── templates/       # Plantillas HTML que usa Django para renderizar las vistas
├── static/          # Archivos estáticos servidos por Django
├── css/             # Estilos del sitio
├── js/              # Scripts del sitio
├── img/             # Imágenes (logo, productos, etc.)
├── Dockerfile        # Imagen Docker de la app
├── docker-compose.yml # Orquesta app + Postgres local para desarrollo
├── .dockerignore
├── .env.example     # Plantilla de variables de entorno (sin valores reales)
├── build.sh         # Script de build usado por Render (install, collectstatic, migrate)
├── index.html
├── manage.py
└── requirements.txt
```

## Requisitos previos

- Python 3.10 o superior
- pip
- (Opcional, para usar Docker) [Docker Desktop](https://www.docker.com/products/docker-desktop/)

## Instalación (local, sin Docker)

1. **Clona el repositorio**
   ```bash
   git clone https://github.com/Mundanesleet/Gestion-menu-como-arroz.git
   cd Gestion-menu-como-arroz
   ```

2. **Crea y activa un entorno virtual**
   ```bash
   python -m venv venv

   # Windows
   venv\Scripts\activate

   # macOS / Linux
   source venv/bin/activate
   ```

3. **Instala las dependencias**
   ```bash
   pip install -r requirements.txt
   ```

4. **(Opcional) Configura variables de entorno**

   Copia `.env.example` a `.env`. Sin este paso, el proyecto funciona igual con SQLite local y `DEBUG=True`:
   ```bash
   cp .env.example .env    # macOS/Linux
   copy .env.example .env  # Windows
   ```

5. **Aplica las migraciones**
   ```bash
   python manage.py migrate
   ```

6. **Levanta el servidor de desarrollo**
   ```bash
   python manage.py runserver
   ```

7. Abre tu navegador en `http://127.0.0.1:8000/`

## Instalación con Docker (alternativa)

Para un entorno de desarrollo reproducible sin instalar Python/Postgres a mano:

```bash
docker compose up --build
```

Esto levanta la app Django junto con un contenedor de PostgreSQL local (independiente de la base de datos real de Neon). Luego, en otra terminal:

```bash
docker compose exec web python manage.py migrate
docker compose exec web python manage.py createsuperuser
```

Abre `http://localhost:8000/`. Ver `docker-compose.yml` para el detalle de cómo están conectados los servicios.

## Variables de entorno

| Variable | Descripción |
|---|---|
| `DJANGO_SECRET_KEY` | Clave secreta de Django. En producción debe ser única y secreta. |
| `DJANGO_DEBUG` | `True` en local, `False` en producción. |
| `DJANGO_ALLOWED_HOSTS` | Dominios permitidos, separados por coma (ej. dominio de Render). |
| `DJANGO_CSRF_TRUSTED_ORIGINS` | Igual que `ALLOWED_HOSTS` pero con el esquema completo (`https://`). Solo necesario en producción. |
| `DATABASE_URL` | Cadena de conexión de PostgreSQL (Neon). Vacío = SQLite local. |
| `CLOUDINARY_URL` | Cadena de conexión de Cloudinary. Vacío = imágenes en disco local. |

En producción (Render), estas variables se configuran directamente en el dashboard de Render, no en un archivo `.env`.

## Despliegue en producción

El proyecto está desplegado en **Render**, usando `build.sh` como Build Command:
```bash
pip install -r requirements.txt
python manage.py collectstatic --no-input
python manage.py migrate
```

La base de datos vive en **Neon** (PostgreSQL serverless) y las imágenes subidas se almacenan en **Cloudinary**, ambos conectados vía las variables de entorno configuradas en Render.

## Uso

- **Menú**: la app `menu` permite crear, ver, editar y eliminar los productos que se muestran en el sitio (nombre, categoría, precio, imagen, descripción).
- **Pedidos**: la app `pedidos` guarda y gestiona los pedidos realizados por los clientes.
- **Cuentas**: la app `cuentas` gestiona el registro e inicio de sesión de usuarios.

Para entrar al panel de administración de Django:
```bash
python manage.py createsuperuser
```
Y accede en `http://127.0.0.1:8000/admin/`

## Proyecto relacionado

Este backend complementa la versión estática del sitio (HTML/CSS/JS + carrito por WhatsApp), disponible en [Como-arroz](https://github.com/Mundanesleet/Como-arroz).
