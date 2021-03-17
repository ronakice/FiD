#!/bin/bash
#SBATCH --account=def-jimmylin         # Jimmy pays for your job
#SBATCH --cpus-per-task=3                # Ask for 3 CPUs
#SBATCH --gres=gpu:v100:1                     # Ask for 4 GPU
#SBATCH --mem=22G                        # Ask for 90 GB of RAM
#SBATCH --time=10:00:00                   # The job will run for 5 hours

touch $SLURM_TMPDIR/test1
cp -r $SLURM_TMPDIR/test1 /project/def-jimmylin/shared_files/FiD/
cp -r /project/def-jimmylin/shared_files/FiD/nq_retriever $SLURM_TMPDIR
cp -r /project/def-jimmylin/shared_files/FiD/tmp_split/psgs_w100.tsv* $SLURM_TMPDIR
source $HOME/Environments/fid/bin/activate
for ITER in {000..021};
do echo $ITER;
python3 generate_passage_embeddings.py \
        --model_path $SLURM_TMPDIR/nq_retriever \
        --passages $SLURM_TMPDIR/psgs_w100.tsv${ITER} \
        --output_path $SLURM_TMPDIR/wikipedia_embeddings${ITER} \
        --shard_id 0 \
        --num_shards 1 \
        --per_gpu_batch_size 500;
cp -r $SLURM_TMPDIR/wikipedia_embeddings${ITER}* /project/def-jimmylin/shared_files/FiD/
done;
cp -r $SLURM_TMPDIR/wikipedia_embeddings* /project/def-jimmylin/shared_files/FiD/tmp_split