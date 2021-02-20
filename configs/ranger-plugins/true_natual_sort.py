import re
from ranger.container.directory import Directory


Directory.sort_dict['natural'] = lambda s: [int(t) if t.isdigit() else t.lower() for t in re.split(r'(\d+)', str(s))]
