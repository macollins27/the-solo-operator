import type { APIRoute } from 'astro';
import { getCollection } from 'astro:content';

export const GET: APIRoute = async ({ site }) => {
  const base = site?.toString().replace(/\/$/, '') ?? '';
  const entries = await getCollection('phrasebook');

  const lines: string[] = [];
  lines.push("# The Solo Operator's Manual");
  lines.push('');
  lines.push(
    '> A phrasebook for non-technical operators who build real software with AI agents. ' +
      'Pick what your agent is doing wrong, get the words to say back.',
  );
  lines.push('');
  lines.push('## Reading modes');
  lines.push('');
  lines.push(`- [The Phrasebook](${base}/phrasebook): symptom-indexed lookup`);
  lines.push(`- [Start Here](${base}/start-here): five foundational moves for new operators`);
  lines.push(`- [Where this came from](${base}/about): origin story and verification discipline`);
  lines.push('');
  lines.push(`Full concatenated body: ${base}/llms-full.txt`);
  lines.push('');
  lines.push('## Phrasebook entries');
  lines.push('');
  for (const entry of entries) {
    lines.push(
      `- [${entry.data.title}](${base}/phrasebook/${entry.id}): ${entry.data.description}`,
    );
  }
  lines.push('');
  lines.push('## Provenance');
  lines.push('');
  lines.push(
    'Distilled from 1,073 working sessions across 46 projects. Aggregate counts only — ' +
      'no client, project, or session identifiers are retained. Refreshed monthly.',
  );

  return new Response(lines.join('\n'), {
    status: 200,
    headers: { 'Content-Type': 'text/plain; charset=utf-8' },
  });
};
