#!/bin/bash

#aligns HCP MNI-aligned volumes to subject space
#
# David Hunt 2019, BrainLife.io Team

#raw_dir="$1"
#bold="$2"
#sbref="$3"

t1="$1"
warp="$2"
bold="$3"
sbref="$4"

# Resample the T1w data to 1.6 isotropic resolution
# This is needed to map to the 7T BOLD data
flirt -interp spline \
-in "$t1" \
-ref "$t1" \
-applyisoxfm 1.6 \
-out ./T1w_acpc_dc_restore.1.6.nii.gz

# Take the newly generated 1.6 isotropic data as reference
# warp the BOLD (7T retinotopic task, which comes in MNI space) 
# into the subject T1w space
applywarp --interp=spline \
-i "$bold" \
-r ./T1w_acpc_dc_restore.1.6.nii.gz \
-w "$warp" \
-o ./aligned_vols/bold.nii.gz

# Also warp the SBREF file to the same native (subject space).
# Single-band reference (SBRef) image. 
# The SBRef image is used for EPI distortion correction. 
applywarp --interp=spline \
-i "$sbref" \
-r ./T1w_acpc_dc_restore.1.6.nii.gz \
-w "$warp" \
-o ./aligned_vols/sbref.nii.gz
