fn main() -> Result<(), Box<dyn std::error::Error>> {
    #[cfg(feature = "dockerproto")]
    {
        println!("cargo:rerun-if-changed=/app/proto/demo.proto");
        tonic_build::compile_protos("/app/proto/demo.proto")?;
    }

    #[cfg(not(feature = "dockerproto"))]
    {
        let proto_file = "/root/Documents/e-commerce-app-demo/src/accounting/pb/demo.proto";
        let proto_include = "/root/Documents/e-commerce-app-demo/src/accounting/pb";

        println!("cargo:rerun-if-changed={}", proto_file);
        println!("cargo:rerun-if-changed={}", proto_include);

        tonic_build::configure()
            .build_server(true)
            .build_client(true)
            // REMOVE THIS ↓↓↓
            // .out_dir("src/generated")
            .compile(&[proto_file], &[proto_include])?;
    }

    Ok(())
}

