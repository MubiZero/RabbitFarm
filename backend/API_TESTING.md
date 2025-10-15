# RabbitFarm API Testing Guide

## Setup

1. **Create .env file**
```bash
cd backend
cp .env.example .env
# Edit .env with your settings
```

2. **Install dependencies**
```bash
npm install
```

3. **Start MySQL** (if using Docker)
```bash
docker-compose up -d mysql
```

4. **Run migrations**
```bash
npm run migrate
```

5. **Seed database**
```bash
npm run seed
```

6. **Start server**
```bash
npm run dev
```

Server should be running at `http://localhost:3000`

---

## Test Credentials

After seeding, you can use these accounts:

- **Owner**: `admin@rabbitfarm.com` / `admin123`
- **Manager**: `manager@rabbitfarm.com` / `manager123`
- **Worker**: `worker@rabbitfarm.com` / `worker123`

---

## API Endpoints

Base URL: `http://localhost:3000/api/v1`

### Health Check

```bash
# Health check
curl http://localhost:3000/health

# API info
curl http://localhost:3000/api/v1
```

---

## Authentication Endpoints

### 1. Register

```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "full_name": "Test User",
    "phone": "+79991234567",
    "role": "worker"
  }'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 4,
      "email": "test@example.com",
      "full_name": "Test User",
      "role": "worker",
      ...
    },
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "message": "Пользователь успешно зарегистрирован"
}
```

### 2. Login

```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@rabbitfarm.com",
    "password": "admin123"
  }'
```

**Save the access_token for subsequent requests!**

### 3. Get Current User Profile

```bash
curl http://localhost:3000/api/v1/auth/me \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 4. Update Profile

```bash
curl -X PUT http://localhost:3000/api/v1/auth/profile \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "full_name": "Updated Name",
    "phone": "+79991234568"
  }'
```

### 5. Change Password

```bash
curl -X POST http://localhost:3000/api/v1/auth/change-password \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "current_password": "admin123",
    "new_password": "newpassword123"
  }'
```

### 6. Refresh Token

```bash
curl -X POST http://localhost:3000/api/v1/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refresh_token": "YOUR_REFRESH_TOKEN"
  }'
```

### 7. Logout

```bash
curl -X POST http://localhost:3000/api/v1/auth/logout \
  -H "Content-Type: application/json" \
  -d '{
    "refresh_token": "YOUR_REFRESH_TOKEN"
  }'
```

---

## Rabbit Endpoints

**Note**: All rabbit endpoints require authentication. Use the access token from login.

### 1. Get Rabbit Statistics

```bash
curl http://localhost:3000/api/v1/rabbits/statistics \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Response:**
```json
{
  "success": true,
  "data": {
    "total": 0,
    "alive": 0,
    "males": 0,
    "females": 0,
    "pregnant": 0,
    "sick": 0,
    "forSale": 0,
    "breedDistribution": []
  }
}
```

### 2. Create Rabbit

```bash
curl -X POST http://localhost:3000/api/v1/rabbits \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "tag_id": "R001",
    "name": "Снежок",
    "breed_id": 1,
    "sex": "male",
    "birth_date": "2024-01-15",
    "color": "Белый",
    "cage_id": 1,
    "status": "healthy",
    "purpose": "breeding",
    "current_weight": 4.5,
    "temperament": "Спокойный"
  }'
```

### 3. Create Rabbit with Photo

```bash
curl -X POST http://localhost:3000/api/v1/rabbits \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -F "tag_id=R002" \
  -F "name=Пушок" \
  -F "breed_id=2" \
  -F "sex=female" \
  -F "birth_date=2024-02-01" \
  -F "color=Серый" \
  -F "status=healthy" \
  -F "purpose=breeding" \
  -F "photo=@/path/to/rabbit.jpg"
```

### 4. Get Rabbit List

```bash
# All rabbits
curl http://localhost:3000/api/v1/rabbits \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# With pagination
curl "http://localhost:3000/api/v1/rabbits?page=1&limit=10" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# Filter by breed
curl "http://localhost:3000/api/v1/rabbits?breed_id=1" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# Filter by sex
curl "http://localhost:3000/api/v1/rabbits?sex=female" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# Filter by status
curl "http://localhost:3000/api/v1/rabbits?status=healthy" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# Search by name or tag
curl "http://localhost:3000/api/v1/rabbits?search=Снежок" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# Sort by birth date
curl "http://localhost:3000/api/v1/rabbits?sort_by=birth_date&sort_order=asc" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# Combine filters
curl "http://localhost:3000/api/v1/rabbits?breed_id=1&sex=male&status=healthy&page=1&limit=20" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 5. Get Rabbit by ID

```bash
curl http://localhost:3000/api/v1/rabbits/1 \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 6. Update Rabbit

```bash
curl -X PUT http://localhost:3000/api/v1/rabbits/1 \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Снежок Белый",
    "current_weight": 5.0,
    "status": "healthy"
  }'
```

### 7. Delete Rabbit

**Note**: Only owners can delete rabbits

```bash
curl -X DELETE http://localhost:3000/api/v1/rabbits/1 \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 8. Get Weight History

```bash
curl http://localhost:3000/api/v1/rabbits/1/weights \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 9. Add Weight Record

```bash
curl -X POST http://localhost:3000/api/v1/rabbits/1/weights \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "weight": 5.2,
    "measured_at": "2024-10-15T10:00:00Z",
    "notes": "Хороший прирост веса"
  }'
```

### 10. Get Pedigree

```bash
# Default 3 generations
curl http://localhost:3000/api/v1/rabbits/1/pedigree \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# Custom generations
curl "http://localhost:3000/api/v1/rabbits/1/pedigree?generations=5" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 11. Upload Photo

```bash
curl -X POST http://localhost:3000/api/v1/rabbits/1/photo \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -F "photo=@/path/to/rabbit.jpg"
```

---

## Using Postman

### Setup

1. **Import Collection** (you can create from these examples)
2. **Set Environment Variables**:
   - `base_url`: `http://localhost:3000/api/v1`
   - `access_token`: (will be set after login)

### Auto-Set Token

In your login request, add this to **Tests** tab:

```javascript
if (pm.response.code === 200) {
    var jsonData = pm.response.json();
    pm.environment.set("access_token", jsonData.data.access_token);
    pm.environment.set("refresh_token", jsonData.data.refresh_token);
}
```

Then in other requests, use: `{{access_token}}` in Authorization header.

---

## Expected Responses

### Success Response Format

```json
{
  "success": true,
  "data": { ... },
  "message": "Success message",
  "timestamp": "2025-10-15T10:00:00.000Z"
}
```

### Error Response Format

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error message",
    "details": [ ... ] // For validation errors
  },
  "timestamp": "2025-10-15T10:00:00.000Z"
}
```

### Paginated Response Format

```json
{
  "success": true,
  "data": {
    "items": [ ... ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "totalPages": 5
    }
  },
  "message": "Success message",
  "timestamp": "2025-10-15T10:00:00.000Z"
}
```

---

## Common Error Codes

| Code | Description |
|------|-------------|
| `BAD_REQUEST` | Invalid request data |
| `UNAUTHORIZED` | No token or invalid token |
| `FORBIDDEN` | Insufficient permissions |
| `NOT_FOUND` | Resource not found |
| `VALIDATION_ERROR` | Request validation failed |
| `SERVER_ERROR` | Internal server error |
| `RATE_LIMIT_EXCEEDED` | Too many requests |

---

## Testing Workflow

### 1. Initial Setup

```bash
# 1. Login as admin
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@rabbitfarm.com","password":"admin123"}'

# Save the access_token from response
export TOKEN="your_access_token_here"
```

### 2. Create Test Rabbits

```bash
# Create male rabbit
curl -X POST http://localhost:3000/api/v1/rabbits \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "tag_id": "M001",
    "name": "Самец №1",
    "breed_id": 1,
    "sex": "male",
    "birth_date": "2023-06-01",
    "status": "healthy",
    "purpose": "breeding",
    "current_weight": 5.0
  }'

# Create female rabbit
curl -X POST http://localhost:3000/api/v1/rabbits \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "tag_id": "F001",
    "name": "Самка №1",
    "breed_id": 1,
    "sex": "female",
    "birth_date": "2023-07-01",
    "status": "healthy",
    "purpose": "breeding",
    "current_weight": 4.5
  }'
```

### 3. Test Operations

```bash
# Get list
curl http://localhost:3000/api/v1/rabbits -H "Authorization: Bearer $TOKEN"

# Get statistics
curl http://localhost:3000/api/v1/rabbits/statistics -H "Authorization: Bearer $TOKEN"

# Add weight
curl -X POST http://localhost:3000/api/v1/rabbits/1/weights \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"weight": 5.2}'

# Get weight history
curl http://localhost:3000/api/v1/rabbits/1/weights -H "Authorization: Bearer $TOKEN"
```

---

## Troubleshooting

### "Cannot connect to MySQL"
```bash
# Check if MySQL is running
docker-compose ps

# Check logs
docker-compose logs mysql

# Restart MySQL
docker-compose restart mysql
```

### "Migration error"
```bash
# Rollback and retry
npm run migrate:undo
npm run migrate
```

### "401 Unauthorized"
- Check if token is valid
- Token expires in 15 minutes
- Use refresh endpoint to get new token

### "403 Forbidden"
- Check user role
- Some endpoints require manager/owner role

### "File upload error"
- Check file size (max 5MB)
- Check file type (only images)
- Ensure uploads directory exists

---

## Next Steps

After testing the API:
1. Test all authentication flows
2. Test CRUD operations for rabbits
3. Test role-based access control
4. Test file uploads
5. Test error handling
6. Start Flutter app development

---

**Happy Testing! 🧪**
