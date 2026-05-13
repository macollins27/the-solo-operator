export default function Home() {
  return (
    <main
      style={{
        maxWidth: "720px",
        margin: "4rem auto",
        padding: "0 1rem",
        lineHeight: 1.6,
      }}
    >
      <h1>MembershipKit</h1>
      <p>
        Community membership manager — the canonical reference project for{" "}
        <a href="https://github.com/macollins27/the-solo-operator">
          The Solo Operator&apos;s Manual
        </a>{" "}
        course.
      </p>
      <p>
        This page is the starter scaffold. As you progress through the
        course&apos;s drills, you&apos;ll add: authentication, dues plans,
        member invitations, events, real-time check-ins, an AI-powered
        directory search, and an audit log — all in your own fork at{" "}
        <code>student/canonical-project/</code>.
      </p>
      <p>
        The reference implementation here is your answer key. Don&apos;t look
        until you&apos;re stuck. The point is to build it yourself.
      </p>
    </main>
  );
}
