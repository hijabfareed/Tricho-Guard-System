function PageHeader({ title, description, action }) {
  return (
    <div className="page-header">
      <div>
        <p className="eyebrow">Care intelligence</p>
        <h2>{title}</h2>
        <p className="page-description">{description}</p>
      </div>
      {action}
    </div>
  )
}

export default PageHeader
