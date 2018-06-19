# .sym file reading library

from collections import OrderedDict

class SymFile:
	def __init__(self,filename):
		self.rom = OrderedDict()
		self.wram = []
		self.sram = []
		self.vram = []
		self.misc = []
		with open(filename) as f:
			lines = [l.strip() for l in f]
			for line in lines:
				if not line:
					continue
				if line.startswith(";"):
					continue
				parts = line.split(" ")[0].split(":")
#				print(parts)
				bank = int(parts[0],16)
				highnibble = parts[1][0]
				if highnibble in ("0","1","2","3","4","5","6","7"):
					if bank in self.rom:
						self.rom[bank].append(line)
					else:
						self.rom[bank]=[line]
				elif highnibble in ("8","9"):
					if bank>1: # edge case: if bank>1, bank:8000 is a ROM label
						if bank in self.rom:
							self.rom[bank].append(line)
						else:
							self.rom[bank]=[line]
					else:
						self.vram.append(line)
				elif highnibble in ("A","B"):
					self.sram.append(line)
				elif highnibble in ("C","D") or parts[1]=="E000": # edge cases: XX:E000 is a valid WRAM label; for bank>1, bank:C000 is a valid sram label
					if bank>1 and parts[1]=="C000":
						self.sram.append(line)
					else:
						self.wram.append(line)
				else:
					self.misc.append(line)
		for k in self.rom:
			self.rom[k].sort()
		self.wram.sort()
		self.vram.sort()
		self.sram.sort()
		self.misc.sort()

	@property
	def all_labels(self):
		ret = []
		for k in self.rom:
			ret.extend(self.rom[k])
		ret.extend(self.wram)
		ret.extend(self.vram)
		ret.extend(self.sram)
		ret.extend(self.misc)
		return ret

	def output(self,f):
		f.write("; ROM\n")
		for bank in self.rom.keys():
			f.write("\n".join(self.rom[bank])+"\n")
		if self.vram:
			f.write("; VRAM\n")
			f.write("\n".join(self.vram)+"\n")
		if self.sram:
			f.write("; SRAM\n")
			f.write("\n".join(self.sram)+"\n")
		if self.wram:
			f.write("; WRAM\n")
			f.write("\n".join(self.wram)+"\n")
		if self.misc:
			f.write("; Other addresses (HRAM)")
			f.write("\n".join(self.misc))
