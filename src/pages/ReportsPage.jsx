import PageHeader from '../components/PageHeader.jsx'
import SectionCard from '../components/SectionCard.jsx'
import { reportHighlights } from '../data/mockData.js'

function ReportsPage() {
  return (
    <div className="page-stack">
      <PageHeader
        title="Reports"
        description="Summarize program performance, patient risk movement, and device compliance."
        action={<button className="primary-button">Generate report</button>}
      />

      <div className="content-grid">
        {reportHighlights.map((report) => (
          <SectionCard key={report.title} title={report.title}>
            <p className="report-copy">{report.detail}</p>
            <button className="ghost-button" type="button">
              Download PDF
            </button>
          </SectionCard>
        ))}
      </div>
    </div>
  )
}

export default ReportsPage
