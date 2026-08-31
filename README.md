# Session Manager

Multiple browser profiles ko isolated sessions ke saath manage karne wala Flutter app.

## Kya bana hai (starter)
- `lib/main.dart` — app entry
- `lib/screens/login_screen.dart` — Login UI
- `lib/screens/dashboard_screen.dart` — Profile list, Start/Stop
- `lib/screens/add_profile_screen.dart` — New profile form
- `lib/screens/browser_session_screen.dart` — Isolated WebView session
- `lib/services/profile_store.dart` — Profiles ka local persistence (SharedPreferences)
- `lib/services/session_isolation_service.dart` — Per-profile cookie isolation

## ⚠️ Zaroori technical note
Android/iOS ka WebView engine **ek hi shared cookie store** use karta hai across
saare WebView instances. Isliye "true" isolated profile jaisa Multilogin/GoLogin
karte hain, wo heavy hai (alag process/container chahiye). Yahan simpler
approach use kiya hai: har profile band karte waqt uske cookies save ho jaate
hain, aur next time wahi profile open karne par sirf uske cookies restore hote
hain (baaki clear). Isse practically alag-alag logins kaam karte hain, lekin
ek time pe do profiles ka session simultaneously "live" nahi rahega jab tak
tum multiple WebView tabs ek saath open na karo (thoda aur kaam lagega uske
liye — batana agar chahiye).

## Mobile pe code karna — GitHub Codespaces se (recommended)
1. GitHub pe naya empty repo banao (GitHub app ya browser se): `session-manager`
2. Repo → **Code** button → **Codespaces** tab → **Create codespace on main**
   (ye browser me hi VS Code khol dega, phone pe bhi chal jaata hai)
3. Codespace ke terminal me:
   ```bash
   git clone <apna-naya-repo-url> .
   ```
4. Is chat se jo files bani hain, unhe codespace me copy karo (drag-drop ya
   terminal me paste karke `cat > filename` se) — ya niche di zip file
   directly GitHub repo me "Add file → Upload files" se upload kar do, phir
   codespace me `git pull`.
5. Flutter SDK codespace me install:
   ```bash
   git clone https://github.com/flutter/flutter.git -b stable --depth 1
   export PATH="$PATH:$PWD/flutter/bin"
   flutter doctor
   flutter pub get
   ```
6. Run/build:
   ```bash
   flutter build apk   # Android APK banane ke liye
   ```
7. Commit + push:
   ```bash
   git add .
   git commit -m "Session manager starter"
   git push
   ```

## Alternative: seedha GitHub app se
GitHub ka official mobile app files ko directly edit/commit karne deta hai
(chhote changes ke liye), lekin `flutter build` jaisa heavy kaam karne ke liye
Codespaces hi sabse aasan hai kyunki wo cloud Linux machine deta hai — tumhare
phone pe kuch install nahi karna padta.
