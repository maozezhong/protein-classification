cur_date=`date "+%s"`
check_root=../models/$cur_date
mkdir $check_root
mkdir -p log/$cur_date

# firstly, freeze all base layers and only learn head layers
python3 main_keras.py \
    --channel 4 \
    --height 224 \
    --width 224 \
    --n_out 28 \
    --predict_threshold 0.5 \
    --learning_rate 1e-02 \
    --check_root $check_root \
    --check_name 'weights.{epoch:02d}-{val_f1_fix:.3f}.hdf5' --epochs 5 \
    --batch_size 32 \
    --stage 1 \
    --useDiffT 0 \
    2>&1 | tee ./log/$cur_date/first_stage.txt

# last, train all layer, base with lr, middle with lr/5, head with lr/10
python3 main_keras.py \
    --channel 4 \
    --height 224 \
    --width 224 \
    --n_out 28 \
    --predict_threshold 0.5 \
    --learning_rate 1e-03 \
    --check_root $check_root \
    --check_name 'weights.{epoch:02d}-{val_f1_fix:.3f}.hdf5' --epochs 100 \
    --batch_size 32 \
    --stage 2 \
    --useDiffT 1 \
    2>&1 | tee ./log/$cur_date/second_stage.txt
