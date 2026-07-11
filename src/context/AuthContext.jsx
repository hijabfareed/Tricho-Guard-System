import { createContext, useContext, useEffect, useMemo, useState } from 'react'

const AuthContext = createContext(null)

const defaultUser = {
  name: 'Dr. Sarah Adams',
  role: 'Senior Trichologist',
  email: 's.adams@trichoguard.ai',
  facility: 'Tricho Guard Care Hub',
}

const storageKey = 'tricho-guard-user'

export function AuthProvider({ children }) {
  const [user, setUser] = useState(() => {
    const savedUser = window.localStorage.getItem(storageKey)
    return savedUser ? JSON.parse(savedUser) : null
  })

  useEffect(() => {
    if (user) {
      window.localStorage.setItem(storageKey, JSON.stringify(user))
      return
    }

    window.localStorage.removeItem(storageKey)
  }, [user])

  const value = useMemo(
    () => ({
      user,
      isAuthenticated: Boolean(user),
      login: ({ email }) => {
        setUser({
          ...defaultUser,
          email: email || defaultUser.email,
        })
      },
      logout: () => setUser(null),
    }),
    [user],
  )

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth() {
  const context = useContext(AuthContext)

  if (!context) {
    throw new Error('useAuth must be used inside AuthProvider')
  }

  return context
}
