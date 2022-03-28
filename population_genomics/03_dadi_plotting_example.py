import os
import dadi
import matplotlib.pyplot as plt

os.chdir("/Users/antoinegradel/Desktop/pinctadapt")
vcf = "Puce_ADN_289inds_10kSNPs_max10missing.vcf.recode.vcf"
popfile = "metadata_marq.txt"
#marquises 30
#takaroa 103
#Ahe 50
#Scilly 25
#Raroia 35
#Japan 7
#indo 39
pop_ids, ns = ['Marquesas', 'Japan'], [10,10] #hear you have to choose the population to compare
#but also the projection of individuals to minimize the computation time
#it's better to choose the number near the little pop
dd = dadi.Misc.make_data_dict_vcf(vcf, popfile)


fig = plt.figure(1, figsize=(10,6))
fig.clear()

ax = fig.add_subplot(2,3,1)
fs = dadi.Spectrum.from_data_dict(dd, pop_ids, ns, polarized = False)
dadi.Plotting.plot_single_2d_sfs(fs, vmin=1e-2, ax=ax)
ax.set_title('Folded original data')

pop_ids, ns = ['Takaroa', 'Japan'], [10,10]
ax = fig.add_subplot(2,3,2)
fs = dadi.Spectrum.from_data_dict(dd, pop_ids, ns, polarized = False)
dadi.Plotting.plot_single_2d_sfs(fs, vmin=1e-2, ax=ax)
ax.set_title('Folded original data')

pop_ids, ns = ['Ahe', 'Japan'], [10,10]
ax = fig.add_subplot(2,3,3)
fs = dadi.Spectrum.from_data_dict(dd, pop_ids, ns, polarized = False)
dadi.Plotting.plot_single_2d_sfs(fs, vmin=1e-2, ax=ax)
ax.set_title('Folded original data')

pop_ids, ns = ['Scilly', 'Japan'], [10,10]
ax = fig.add_subplot(2,3,4)
fs = dadi.Spectrum.from_data_dict(dd, pop_ids, ns, polarized = False)
dadi.Plotting.plot_single_2d_sfs(fs, vmin=1e-2, ax=ax)
ax.set_title('Folded original data')

pop_ids, ns = ['Indonesia', 'Japan'], [10,10]
ax = fig.add_subplot(2,3,5)
fs = dadi.Spectrum.from_data_dict(dd, pop_ids, ns, polarized = False)
dadi.Plotting.plot_single_2d_sfs(fs, vmin=1e-2, ax=ax)
ax.set_title('Folded original data')

pop_ids, ns = ['Raroia', 'Japan'], [10,10]
ax = fig.add_subplot(2,3,6)
fs = dadi.Spectrum.from_data_dict(dd, pop_ids, ns, polarized = False)
dadi.Plotting.plot_single_2d_sfs(fs, vmin=1e-2, ax=ax)
ax.set_title('Folded original data')

fig.tight_layout()
plt.show()
