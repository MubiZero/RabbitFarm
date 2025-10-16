# 🚀 Quick Test Guide - RabbitFarm

## Current Status ✅

- ✅ Backend running on http://localhost:3000
- ✅ Flutter app running on Chrome (localhost:8080)
- ✅ API URL updated to localhost:3000

---

## Test Authentication NOW!

### Step 1: Hot Reload Flutter App
In the Flutter terminal, press `r` (hot reload)

You should see:
```
Performing hot reload...
Reloaded 1 of XXX libraries in XXXms
```

### Step 2: Try Login
The app should now successfully connect to backend!

**Test Credentials** (pre-filled):
- Email: `admin@rabbitfarm.com`
- Password: `admin123`

Click "Войти" (Login)

### Step 3: Expected Result ✅

**Success case**:
1. Loading indicator appears
2. You're redirected to home screen
3. See welcome message: "Добро пожаловать, Администратор!"
4. See your role: "Роль: Владелец"
5. Backend connection indicator: ✅ "Backend API подключен"

**In backend terminal you should see**:
```
POST /api/v1/auth/login [32m200[0m
```

**In Flutter terminal you should see**:
```
🌐 REQUEST[POST] => PATH: /auth/login
✅ RESPONSE[200] => PATH: /auth/login
```

---

## What's Working

### Backend ✅
- Server: http://localhost:3000
- Database: MySQL (Docker)
- Endpoints: All 18 ready
- Test data: 3 users, 8 breeds, 10 cages, 6 feeds

### Mobile App ✅
- Platform: Web (Chrome)
- URL: http://localhost:8080
- Login screen: Ready
- Register screen: Ready
- API client: Configured
- State management: Riverpod

---

## Test Scenarios

### 1. Login Test
- [x] Open app → Login screen appears
- [ ] Enter credentials
- [ ] Click login button
- [ ] Loading state shows
- [ ] Redirected to home
- [ ] User name displayed
- [ ] Profile menu works
- [ ] Logout works

### 2. Register Test
- [ ] Click "Зарегистрироваться"
- [ ] Fill registration form
- [ ] Submit
- [ ] Account created
- [ ] Auto-login and redirect

### 3. Token Persistence Test
- [ ] Login successfully
- [ ] Refresh page (F5)
- [ ] Should stay logged in
- [ ] No redirect to login

### 4. Logout Test
- [ ] Click profile menu (top right)
- [ ] Click "Выйти"
- [ ] Redirect to login screen
- [ ] Tokens cleared

---

## Debugging

### Check Backend Logs
Backend terminal should show:
```
POST /api/v1/auth/login [200]
Executing (default): SELECT `id`, `email`...
User logged in successfully {"userId":1,"email":"admin@rabbitfarm.com"}
```

### Check Flutter Logs
Flutter terminal should show:
```
🌐 REQUEST[POST] => PATH: /auth/login
📤 Data: {email: admin@rabbitfarm.com, password: admin123}
✅ RESPONSE[200] => PATH: /auth/login
📥 Data: {success: true, message: Вход выполнен успешно, data: {...}}
```

### Check Browser Console
Open Chrome DevTools (F12), should see:
- No CORS errors
- Network tab shows: POST /api/v1/auth/login → 200 OK
- Response contains access_token and user data

---

## Common Issues

### Issue 1: "Network Error"
**Cause**: Backend not running or wrong URL

**Fix**:
```bash
# Check backend is running
curl http://localhost:3000/health

# Should return:
# {"success":true,"message":"Server is running",...}
```

### Issue 2: CORS Error
**Cause**: Backend CORS not configured for localhost:8080

**Check**: Backend src/app.js should have:
```javascript
app.use(cors({
  origin: '*', // or specifically 'http://localhost:8080'
}));
```

**Fix**: Backend already configured! ✅

### Issue 3: "401 Unauthorized"
**Cause**: Wrong credentials

**Fix**: Use correct test credentials:
- Email: `admin@rabbitfarm.com`
- Password: `admin123`

### Issue 4: Hot Reload Not Working
**Fix**: Press `R` (capital R) for hot restart instead

---

## Next Steps After Login Success

1. **Explore Home Screen**
   - See welcome message
   - Check profile menu
   - Test logout

2. **Test Registration**
   - Create new account
   - Verify it works

3. **Next Session: Add Rabbits List**
   - Fetch rabbits from API
   - Display in list
   - Add search/filter
   - Create new rabbit

---

## Success Criteria ✅

- [x] Backend running
- [x] Flutter app running
- [x] API URL configured
- [ ] Login works (test now!)
- [ ] User data displayed
- [ ] Logout works
- [ ] Registration works

---

## Commands Reference

### Backend
```bash
# Start
cd backend
npm run dev

# Test
npm run test:api

# Check health
curl http://localhost:3000/health
```

### Flutter
```bash
# Run on Chrome
cd mobile
flutter run -d chrome

# Hot reload
Press 'r' in terminal

# Hot restart
Press 'R' in terminal

# Quit
Press 'q' in terminal
```

### Docker
```bash
# Check MySQL
docker ps

# Stop MySQL
docker-compose -f docker-compose-simple.yml down

# Start MySQL
docker-compose -f docker-compose-simple.yml up -d
```

---

## Video Walkthrough (What You Should See)

1. **Login Screen**
   - Green "RabbitFarm" icon
   - Email field (pre-filled)
   - Password field (pre-filled)
   - "Запомнить меня" checkbox
   - Green "Войти" button
   - Link to registration
   - Blue hint box with test credentials

2. **After Login Click**
   - Button shows loading spinner
   - ~1 second delay
   - Screen transitions to home

3. **Home Screen**
   - Green AppBar: "Мои кролики"
   - Profile menu icon (top right)
   - Center: Large rabbit icon
   - "Добро пожаловать, Администратор!"
   - "Роль: Владелец"
   - White card with "Список кроликов"
   - Green success indicator at bottom
   - Green FAB button (bottom right)

4. **Profile Menu**
   - Click top right → menu appears
   - "Администратор" (profile option)
   - "Выйти" (logout option)

5. **After Logout**
   - Back to login screen
   - Fields empty this time
   - Can login again

---

**Ready to Test!** 🚀

Just press `r` in Flutter terminal and try logging in!

---

**Last Updated**: 2025-10-15 23:17
**Backend Status**: 🟢 Running
**Flutter Status**: 🟢 Running
**API Connection**: ⏳ Testing needed
