"""Offline integrity checks for the packaged figure inputs and outputs."""
from pathlib import Path
import csv, hashlib, json, sys

root=Path(__file__).resolve().parents[1]
manifest=json.loads((root/'docs/input_manifest.json').read_text())
for row in json.loads((root/'docs/code_checksums.json').read_text()):
    assert hashlib.sha256((root/row['path']).read_bytes()).hexdigest()==row['sha256'],f'Code checksum mismatch: {row["path"]}'
for row in manifest:
    path=root/row['path']
    if not path.is_file(): raise SystemExit(f'Missing required input: {row["path"]}. See docs/data.md for the required inputs.')
    assert hashlib.sha256(path.read_bytes()).hexdigest()==row['sha256'],f'Checksum mismatch: {row["path"]}'
with (root/'data/equity/figure2_lsoa.csv').open() as f: rows=list(csv.DictReader(f))
assert len(rows)==4835 and len({r['LSOA11CD'] for r in rows})==4835
assert sum(r['temp_baseline'] not in ('NA','','NaN') for r in rows)==4831
with (root/'data/health/citywide_results.csv').open() as f: rows=list(csv.DictReader(f))
for scenario,expected in [('green30',38.37),('target30',50.40)]:
    r=[r for r in rows if r['scenario']==scenario and r['cause']=='all_cause' and r['rr_variant']=='central']
    assert len(r)==1 and abs(float(r[0]['deaths_averted'])-expected)<.005
if '--figures' in sys.argv:
    for name in ['figure1_main_v03_20261111.png','figure1_sm_ssp370_ssp585_v01_20261112.png','figure2.png','figure3_main_v03_20261111.png',
                 'figure4_citywide_cobenefits_release_v1.png','figure5_borough_cobenefits_release_v1.png',
                 'figure6_svi_green30_target30_seasonal_v03.png',
                 'figure7_svi_main_seasonal_v06.png','extended_data_figure1.png',
                 'figure6_supplement_green_overlay_seasonal_20261112_v2.png',
                 'figure6_supplement_target_overlay_seasonal_20261112_v2.png',
                 'fig7_ab_supplement_all_five_seasonal_20261112_v2.png',
                 'figure7_supp_indicator_shares_seasonal_v01.png']:
        path=root/'figures'/name
        assert path.is_file() and path.stat().st_size>1000,f'Missing/empty output: {name}'
print(f'PASS: {len(manifest)} input checksums; Figure 2 sample and seasonal-health anchors.'
      + (' Expected figure outputs present.' if '--figures' in sys.argv else ''))
