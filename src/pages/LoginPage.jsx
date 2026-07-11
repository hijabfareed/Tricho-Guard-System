import { useState } from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { useAuth } from '../context/AuthContext.jsx'

function LoginPage() {
  const { isAuthenticated, login } = useAuth()
  const location = useLocation()
  const [email, setEmail] = useState('s.adams@trichoguard.ai')
  const [password, setPassword] = useState('TrichoGuard')

  if (isAuthenticated) {
    return <Navigate to={location.state?.from || '/dashboard'} replace />
  }

  return (
    <div className="login-page">
      <section className="login-hero">
        <p className="eyebrow">Next-generation scalp care</p>
        <h1>AI-IoT healthcare command center for proactive trichology.</h1>
        <p>
          Monitor wearable sensor data, prioritize patient risk, and review explainable AI
          scalp analysis in one responsive clinical workspace.
        </p>
        <div className="login-highlights">
          <div>
            <strong>Real-time telemetry</strong>
            <span>Temperature, moisture, and pH trends from connected devices.</span>
          </div>
          <div>
            <strong>Predictive AI review</strong>
            <span>Faster detection of scalp disorders with actionable recommendations.</span>
          </div>
        </div>
      </section>

      <form
        className="login-card"
        onSubmit={(event) => {
          event.preventDefault()
          login({ email, password })
        }}
      >
        <div>
          <p className="eyebrow">Secure access</p>
          <h2>Sign in to Tricho Guard</h2>
        </div>

        <label className="field">
          <span>Email</span>
          <input value={email} onChange={(event) => setEmail(event.target.value)} type="email" />
        </label>

        <label className="field">
          <span>Password</span>
          <input
            value={password}
            onChange={(event) => setPassword(event.target.value)}
            type="password"
          />
        </label>

        <button type="submit" className="primary-button">
          Open dashboard
        </button>

        <p className="helper-text">Demo access uses mock authentication for product preview.</p>
      </form>
    </div>
  )
}

export default LoginPage
