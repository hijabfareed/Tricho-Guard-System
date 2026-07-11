import { useState } from 'react'
import { NavLink, Outlet, useLocation } from 'react-router-dom'
import { navigationItems } from '../data/mockData.js'
import { useAuth } from '../context/AuthContext.jsx'

function AppLayout() {
  const [menuOpen, setMenuOpen] = useState(false)
  const { pathname } = useLocation()
  const { user, logout } = useAuth()

  return (
    <div className="app-shell">
      <aside className={`sidebar ${menuOpen ? 'sidebar-open' : ''}`}>
        <div className="brand-card">
          <div className="brand-mark">TG</div>
          <div>
            <p className="eyebrow">AI-IoT Healthcare</p>
            <h1>Tricho Guard</h1>
          </div>
        </div>

        <nav className="sidebar-nav" aria-label="Primary">
          {navigationItems.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              className={({ isActive }) => `nav-link ${isActive ? 'nav-link-active' : ''}`}
              onClick={() => setMenuOpen(false)}
            >
              {item.label}
            </NavLink>
          ))}
        </nav>

        <div className="sidebar-footer">
          <p className="sidebar-user">{user?.name}</p>
          <p className="sidebar-role">{user?.role}</p>
          <button type="button" className="ghost-button" onClick={logout}>
            Sign out
          </button>
        </div>
      </aside>

      <div className="content-shell">
        <header className="topbar">
          <div>
            <p className="eyebrow">Connected clinic workspace</p>
            <h2>{navigationItems.find((item) => item.to === pathname)?.label ?? 'Overview'}</h2>
          </div>

          <div className="topbar-actions">
            <div className="status-pill">54 IoT devices online</div>
            <button
              type="button"
              className="menu-button"
              onClick={() => setMenuOpen((open) => !open)}
              aria-label="Toggle navigation"
            >
              ☰
            </button>
          </div>
        </header>

        <main className="page-content">
          <Outlet />
        </main>
      </div>
    </div>
  )
}

export default AppLayout
