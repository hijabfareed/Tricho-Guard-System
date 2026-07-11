import PageHeader from '../components/PageHeader.jsx'
import SectionCard from '../components/SectionCard.jsx'
import { useAuth } from '../context/AuthContext.jsx'

function ProfilePage() {
  const { user } = useAuth()

  return (
    <div className="page-stack">
      <PageHeader
        title="Profile management"
        description="Maintain clinician details, notification preferences, and workplace information."
      />

      <SectionCard title="Account details" subtitle="Preview of the active authenticated user profile.">
        <div className="profile-grid">
          <label className="field">
            <span>Full name</span>
            <input type="text" value={user?.name ?? ''} readOnly />
          </label>
          <label className="field">
            <span>Email</span>
            <input type="email" value={user?.email ?? ''} readOnly />
          </label>
          <label className="field">
            <span>Role</span>
            <input type="text" value={user?.role ?? ''} readOnly />
          </label>
          <label className="field">
            <span>Facility</span>
            <input type="text" value={user?.facility ?? ''} readOnly />
          </label>
        </div>
      </SectionCard>
    </div>
  )
}

export default ProfilePage
