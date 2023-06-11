import std;
import mir.ndslice;
import kaleidic.lubeck : mtimes;

enum N = 3000;

alias Matrix = Slice!(double*, 2);

Matrix buildMatrix(float[] raw) {
    auto res = slice!(double)(N, N);
    int i,j;
    foreach(ref row; res) {
        foreach(ref x; row) {
            x = raw[i*N + j];
            j++;
            if (j == N) {
                j = 0;
            }
        }
        i++;
    }
    return res;
}

void mul(Matrix a, Matrix b, out Matrix res)
{
    res = mtimes(a, b);
}

Matrix A, B, C;

void main()
{
    import std.datetime.stopwatch: AutoStart, StopWatch;

    auto all_raw = cast(float[]) read("/tmp/matmul", float.sizeof*N*N*3);
    auto A_raw = all_raw[0..N*N];
    auto B_raw = all_raw[N*N..N*N*2];
    auto C_raw = all_raw[N*N*2..N*N*3];
    auto A = buildMatrix(A_raw);
    auto B = buildMatrix(B_raw);
    
    // start calculation
    Matrix results;
    auto gflops = 2.0*N*N*N;
    auto sw = StopWatch(AutoStart.no);
    foreach(_; 0..20) {
        sw.start();
        mul(A, B, results);
        sw.stop();
        long nsecs = sw.peek.total!"nsecs";
        long msecs = sw.peek.total!"msecs";
        writefln("%f GFLOPS -- %.2f ms", gflops/nsecs, msecs);
        sw.reset();
    }
    float res_sum = 0.0;
    foreach(ref row; results)
        foreach(ref el; row)
            res_sum += el;
    writeln("Check that readed result: ", sum(cast(float[]) C_raw), " equals calculated sum: ", res_sum);
}
