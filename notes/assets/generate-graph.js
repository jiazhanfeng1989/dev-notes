const fs = require('fs');
const path = require('path');
const matter = require('gray-matter');

const vaultPath = '../';
const outputPath = './graph.json';

const files = fs.readdirSync(vaultPath).filter(f => f.endsWith('.md'));

const nodes = [];
const edges = [];

const fileToNoteId = {}; // fileName → frontmatter.id 映射
const fileNames = [];    // 所有不含扩展名的文件名

for (const file of files) {
  const fullPath = path.join(vaultPath, file);
  const content = fs.readFileSync(fullPath, 'utf-8');
  const fm = matter(content);
  const fileName = file.replace(/\.md$/, '');
  const noteId = fm.data?.id || fileName;
  const title = fm.data?.title || fileName;

  fileToNoteId[fileName] = noteId;
  fileNames.push(fileName);

  if (fileName == 'root') {
    nodes.push({
      data: {
        id: 'root',
        label: 'Root',
        url: '/'
      }
    });
  } else {
    nodes.push({
      data: {
        id: fileName,
        label: title,
        url: `/notes/${noteId}`
      }
    });
  }
}

// 建立 root → 一级 的边
for (const fileName of fileNames) {
  const parts = fileName.split('.');

  if (parts.length === 1) {
    if (fileName === 'root') continue;
    edges.push({
      data: {
        source: 'root',
        target: fileName
      }
    });
  } else {
    const parent = parts.slice(0, -1).join('.');
    edges.push({
      data: {
        source: parent,
        target: fileName
      }
    });
  }
}

fs.writeFileSync(outputPath, JSON.stringify({ nodes, edges }, null, 2));
console.log('✅ graph.json successfully!');