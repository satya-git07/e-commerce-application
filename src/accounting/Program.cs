using Accounting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0

// Explicit Main method required for entry point
public class Program
{
    public static void Main(string[] args)
    {
        Console.WriteLine("Accounting service started");

        // Set up the environment
        Environment.GetEnvironmentVariables()
            .FilterRelevant()
            .OutputInOrder();

        // Create and run the host
        var host = Host.CreateDefaultBuilder(args)
            .ConfigureServices(services =>
            {
                services.AddSingleton<Consumer>();
            })
            .Build();

        var consumer = host.Services.GetRequiredService<Consumer>();
        consumer.StartListening();

        host.Run();
    }
}

