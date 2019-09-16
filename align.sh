#!/bin/bash

#aligns HCP MNI-aligned volumes to subject space

raw_dir="$1"
bold="$2"
sbref="$3"

flirt -interp spline \
-in "$raw_dir"/T1w_acpc_dc_restore.nii.gz \
-ref "$raw_dir"/T1w_acpc_dc_restore.nii.gz \
-applyisoxfm 1.6 \
-out "$raw_dir"/T1w_acpc_dc_restore.1.6.nii.gz

applywarp --interp=spline \
-i "$bold" \
-r "$raw_dir"/T1w_acpc_dc_restore.1.6.nii.gz \
-w "$raw_dir"/standard2acpc_dc.nii.gz \
-o ./aligned_vols/bold.nii.gz

applywarp --interp=spline \
-i "$sbref" \
-r "$raw_dir"/T1w_acpc_dc_restore.1.6.nii.gz \
-w "$raw_dir"/standard2acpc_dc.nii.gz \
-o ./aligned_vols/sbref.nii.gz
