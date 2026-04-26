# 🔗 Desafío Dígrafo — Guía completa de despliegue

**Materia:** Fundamentos de Computación  
**Docente:** Dra. Marianela Soledad Reinhardt  
**Contexto:** Actividad interactiva para Unidad III — Grafos y Árboles

---

## Estructura de archivos

Creá un repositorio en GitHub con esta estructura exacta:

```
digraph-challenge/
│
├── challenge.html          ← App mobile (celulares vía QR)
├── leaderboard.html        ← Panel de ranking para PC (durante la expo)
├── presentacion_digrafos_v3.html  ← Presentación principal (PC)
│
├── supabase_setup.sql      ← SQL para ejecutar UNA SOLA VEZ en Supabase
└── README.md               ← Este archivo
```

> Vercel sirve archivos HTML estáticos directamente desde la raíz del repo.  
> No hace falta ningún `package.json`, framework, ni configuración extra.

---

## PASO 1 — Crear la base de datos en Supabase

### 1.1 Crear proyecto
1. Ir a [supabase.com](https://supabase.com) → **New Project**
2. Elegí un nombre (ej. `fundamentos-grafos`), región más cercana, contraseña segura
3. Esperá ~2 minutos a que inicialice

### 1.2 Ejecutar el SQL
1. En el sidebar: **SQL Editor** → **New Query**
2. Pegá **todo** el contenido de `supabase_setup.sql`
3. Click en **Run** (o Ctrl+Enter)
4. Deberías ver las columnas de la tabla en el resultado

### 1.3 Obtener credenciales
En el sidebar: **Settings** → **API**

Copiá estos dos valores:
```
Project URL:    https://xxxxxxxxxxxxxxxx.supabase.co
anon public:    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...  (clave larga)
```

---

## PASO 2 — Pegar credenciales en los archivos

### En `challenge.html` (buscar las líneas marcadas con ⚙️):
```javascript
const SB_URL = 'https://xxxxxxxxxxxxxxxx.supabase.co';   // ← tu URL real
const SB_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'; // ← tu anon key real
```

### En `leaderboard.html` (mismas líneas + la URL del challenge):
```javascript
const SB_URL        = 'https://xxxxxxxxxxxxxxxx.supabase.co';
const SB_KEY        = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
const CHALLENGE_URL = 'https://TU-REPO.vercel.app/challenge.html'; // ← después del deploy
```

> ⚠️ No subas las credenciales a un repo **público**. Si el repo es privado, está bien.  
> La `anon key` solo permite insertar y leer resultados completados — no puede borrar ni modificar.

---

## PASO 3 — Subir a Vercel

### 3.1 Crear repo en GitHub
```bash
git init
git add .
git commit -m "Initial commit - digraph challenge"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/digraph-challenge.git
git push -u origin main
```

### 3.2 Conectar con Vercel
1. Ir a [vercel.com](https://vercel.com) → **Add New Project**
2. Importar el repositorio de GitHub
3. **No cambies ninguna configuración** — Vercel detecta automáticamente archivos estáticos
4. Click en **Deploy**

### 3.3 Obtener URL
Una vez deployado, la URL será algo como:
```
https://digraph-challenge.vercel.app
```

Tus URLs finales:
- Challenge (celular):  `https://digraph-challenge.vercel.app/challenge.html`
- Leaderboard (PC):     `https://digraph-challenge.vercel.app/leaderboard.html`
- Presentación (PC):    `https://digraph-challenge.vercel.app/presentacion_digrafos_v3.html`

---

## PASO 4 — Actualizar el QR en la presentación

Abrí `presentacion_digrafos_v3.html`, buscá esta línea en el `<script>`:
```javascript
const CHALLENGE_URL = 'challenge.html';
```
Reemplazala con la URL completa:
```javascript
const CHALLENGE_URL = 'https://digraph-challenge.vercel.app/challenge.html';
```

También en `leaderboard.html`:
```javascript
const CHALLENGE_URL = 'https://digraph-challenge.vercel.app/challenge.html';
```

Luego hacé `git add . && git commit -m "update URLs" && git push` y Vercel re-deploya automáticamente.

---

## PASO 5 — Agregar los integrantes

En `presentacion_digrafos_v3.html`, buscá el bloque `id="integrantes-list"` y reemplazá cada `— pendiente —` con el nombre real:

```html
<div class="integrante-row">
  <span class="int-num">01</span>
  <span class="int-name">Nombre Apellido</span>
</div>
```

---

## Uso el día de la clase

| Momento | Acción |
|---|---|
| Antes de entrar al aula | Abrí `leaderboard.html` en una pestaña del navegador |
| Al mostrar la portada | Proyectá el QR de la presentación — pediles que escaneen |
| Mientras esperás que participen | Mostrá el leaderboard en pantalla completa (F11) |
| Al empezar la expo | Avanzá con flechas ← → del teclado en la presentación |

### El leaderboard se actualiza cada 10 segundos automáticamente.

---

## Sistema de puntaje

| Arista | Puntos base | Motivo |
|---|---|---|
| T1 → T3 | 250 pts | T3 es convergencia, más difícil |
| T2 → T3 | 250 pts | ídem |
| T3 → T4 | 200 pts | nodo intermedio |
| T4 → T5 | 150 pts | secuencia final |

**Multiplicador por tiempo:**
- Segundos 0–60:  `×2.0` a `×1.5`
- Segundos 60–120: `×1.5` a `×1.0`
- Más de 120s:    `×1.0` (mínimo)

**Penalización:** −75 pts por cada arista incorrecta.

**Puntaje máximo teórico:** ~1700 pts (todo perfecto en <5 segundos)

---

## Limpiar entre usos

En Supabase → SQL Editor:
```sql
-- Borrar todos los resultados (para reusar la actividad):
TRUNCATE TABLE digraph_challenge RESTART IDENTITY;
```

---

## Troubleshooting

| Problema | Solución |
|---|---|
| El QR no carga | Necesitás conexión a internet para la API de QR Server |
| No se guardan resultados | Verificá que `SB_URL` y `SB_KEY` estén correctos y sin espacios extra |
| El leaderboard muestra error | Revisá que el RLS esté activo y las policies existan en Supabase |
| El challenge se ve mal en el celular | Asegurate de abrir desde Chrome/Safari mobile, no desde el preview del QR reader |
| Vercel no deploya | Revisá que no haya errores de sintaxis en los HTML (no debería haber ninguno) |
